# frozen_string_literal: true

require "spec_helper"

describe "User prints the initiative", type: :feature do
  include_context "initiative administration"

  context "when initiative update" do
    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_initiatives.initiatives_path
      page.find(".action-icon--edit").click
    end

    it "Updates initiative data" do
      within ".edit_initiative" do
        fill_in :initiative_hashtag, with: "#hashtag"
      end

      find("*[type=submit]").click

      within ".callout-wrapper" do
        expect(page).to have_content("successfully")
      end
    end
  end
end
