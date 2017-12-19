# frozen_string_literal: true

require "spec_helper"

describe "Admin manages initiative features", type: :feature do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  let!(:initiative) { create(:initiative, organization: organization) }

  context "when adds a feature" do
    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_initiatives.features_path(initiative)

      find("button[data-toggle=add-feature-dropdown]").click

      within "#add-feature-dropdown" do
        find(".dummy").click
      end

      within ".new_feature" do
        fill_in_i18n(
          :feature_name,
          "#feature-name-tabs",
          en: "My feature",
          ca: "La meva funcionalitat",
          es: "Mi funcionalitat"
        )

        within ".global-settings" do
          all("input[type=checkbox]").last.click
        end

        within ".default-step-settings" do
          all("input[type=checkbox]").first.click
        end

        click_button "Add feature"
      end
    end

    it "is successfully created" do
      within ".callout-wrapper" do
        expect(page).to have_content("successfully")
      end

      expect(page).to have_content("My feature")
    end

    context "and then edit it" do
      before do
        within find("tr", text: "My feature") do
          page.find(".action-icon--configure").click
        end
      end

      it "sucessfully displays initial values in the form" do
        within ".global-settings" do
          expect(all("input[type=checkbox]").last).to be_checked
        end

        within ".default-step-settings" do
          expect(all("input[type=checkbox]").first).to be_checked
        end
      end

      it "successfully edits it" do
        click_button "Update"

        within ".callout-wrapper" do
          expect(page).to have_content("successfully")
        end
      end
    end
  end

  context "when edit a feature" do
    let(:feature_name) do
      {
        en: "My feature",
        ca: "La meva funcionalitat",
        es: "Mi funcionalitat"
      }
    end

    let!(:feature) do
      create(:feature, name: feature_name, participatory_space: initiative)
    end

    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_initiatives.features_path(initiative)
    end

    it "updates the feature" do
      within ".feature-#{feature.id}" do
        page.find(".action-icon--configure").click
      end

      within ".edit_feature" do
        fill_in_i18n(
          :feature_name,
          "#feature-name-tabs",
          en: "My updated feature",
          ca: "La meva funcionalitat actualitzada",
          es: "Mi funcionalidad actualizada"
        )

        within ".global-settings" do
          all("input[type=checkbox]").last.click
        end

        within ".default-step-settings" do
          all("input[type=checkbox]").first.click
        end

        click_button "Update"
      end

      within ".callout-wrapper" do
        expect(page).to have_content("successfully")
      end

      expect(page).to have_content("My updated feature")

      within find("tr", text: "My updated feature") do
        page.find(".action-icon--configure").click
      end

      within ".global-settings" do
        expect(all("input[type=checkbox]").last).to be_checked
      end

      within ".default-step-settings" do
        expect(all("input[type=checkbox]").first).to be_checked
      end
    end
  end

  context "when remove a feature" do
    let(:feature_name) do
      {
        en: "My feature",
        ca: "La meva funcionalitat",
        es: "Mi funcionalitat"
      }
    end

    let!(:feature) do
      create(:feature, name: feature_name, participatory_space: initiative)
    end

    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_initiatives.features_path(initiative)
    end

    it "removes the feature" do
      within ".feature-#{feature.id}" do
        page.find(".action-icon--remove").click
      end

      expect(page).to have_no_content("My feature")
    end
  end

  context "when publish and unpublish a feature" do
    let!(:feature) do
      create(:feature, participatory_space: initiative, published_at: published_at)
    end

    let(:published_at) { nil }

    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_initiatives.features_path(initiative)
    end

    context "when the feature is unpublished" do
      it "publishes the feature" do
        within ".feature-#{feature.id}" do
          page.find(".action-icon--publish").click
        end

        within ".feature-#{feature.id}" do
          expect(page).to have_css(".action-icon--unpublish")
        end
      end
    end

    context "when the feature is published" do
      let(:published_at) { Time.current }

      it "unpublishes the feature" do
        within ".feature-#{feature.id}" do
          page.find(".action-icon--unpublish").click
        end

        within ".feature-#{feature.id}" do
          expect(page).to have_css(".action-icon--publish")
        end
      end
    end
  end
end
