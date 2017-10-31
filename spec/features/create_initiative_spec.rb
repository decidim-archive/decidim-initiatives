# frozen_string_literal: true

require 'spec_helper'

describe 'Initiative', type: :feature do
  let(:organization) { create(:organization) }
  let(:authorized_user) { create(:user, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)

    create(:authorization, user: authorized_user)
    login_as authorized_user, scope: :user

    visit decidim_initiatives.initiatives_path
  end

  context 'Access to functionality' do
    it 'Initiatives page contains a create initiative button' do
      expect(page).to have_content('New initiative')
    end
  end

  context 'Create an initiative' do
    let(:initiative_type) { create(:initiatives_type, organization: organization) }
    let!(:other_initiative_type) { create(:initiatives_type, organization: organization) }
    let!(:initiative_type_scope) { create(:initiatives_type_scope, type: initiative_type)}

    before do
      visit decidim_initiatives.create_initiative_path(id: :select_initiative_type)
    end

    context 'Select initiative type' do
      it 'Offers contextual help' do
        within '.callout.secondary' do
          expect(page).to have_content('Select the initiative type')
        end
      end

      it 'Shows the available initiative types' do
        within 'main' do
          expect(page).to have_content(translated(initiative_type.title, locale: :en))
          expect(page).to have_content(ActionView::Base.full_sanitizer.sanitize(translated(initiative_type.description, locale: :en), tags: []))
        end
      end

      it 'Do not show initiative types without related scopes' do
        within 'main' do
          expect(page).not_to have_content(translated(other_initiative_type.title, locale: :en))
          expect(page).not_to have_content(ActionView::Base.full_sanitizer.sanitize(translated(other_initiative_type.description, locale: :en), tags: []))
        end
      end
    end

    context 'Fill basic data' do
      before do
        find_button('Select').click
      end

      it 'Has a hidden field with the selected initiative type' do
        expect(page).to have_xpath("//input[@id='initiative_type_id']", visible: false)
        expect(find(:xpath, "//input[@id='initiative_type_id']", visible: false).value).to eq(initiative_type.id.to_s)
      end

      it 'Have fields for title and description' do
        expect(page).to have_xpath("//input[@id='initiative_title']")
        expect(page).to have_xpath("//input[@id='initiative_description']", visible: false)
      end
    end
  end
end