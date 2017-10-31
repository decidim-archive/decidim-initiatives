# frozen_string_literal: true

require 'spec_helper'

describe 'Initiatives', type: :feature do
  let(:organization) { create(:organization) }
  let(:base_initiative) do
    create(:initiative, organization: organization)
  end

  before do
    switch_to_host(organization.host)
  end

  context 'when there are some published assemblies' do
    let!(:initiative) { base_initiative }
    let!(:unpublished_initiative) { create(:initiative, :created, organization: organization) }

    before do
      visit decidim_initiatives.initiatives_path
    end

    context 'accessing from the homepage' do
      it 'the menu link is shown' do
        visit decidim.root_path

        within '.main-nav' do
          expect(page).to have_content('Initiatives')
          click_link 'Initiatives'
        end

        expect(current_path).to eq decidim_initiatives.initiatives_path
      end
    end

    it 'lists all the assemblies' do
      within '#initiatives-count' do
        expect(page).to have_content('1')
      end

      within '#initiatives' do
        expect(page).to have_content(translated(initiative.title, locale: :en))
        expect(page).not_to have_content(translated(unpublished_initiative.title, locale: :en))
      end
    end

    it 'links to the individual initiative page' do
      click_link(translated(initiative.title, locale: :en))
      expect(current_path).to eq decidim_initiatives.initiative_path(initiative)
    end
  end
end
