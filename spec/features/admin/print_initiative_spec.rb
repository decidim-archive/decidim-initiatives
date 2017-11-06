# frozen_string_literal: true

require 'spec_helper'

describe 'User prints the initiative', type: :feature do
  include_context 'initiative administration'

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_initiatives.initiatives_path
  end

  context 'Initiative print' do
    before do
      page.find('.action-icon--print').click
    end

    it 'shows a printable form with all available data about the initiative' do
      within 'main' do
        expect(page).to have_content(translated(initiative.title, locale: :en))
        expect(page).to have_content(ActionView::Base.full_sanitizer.sanitize(translated(initiative.description, locale: :en), tags: []))
      end
    end
  end
end