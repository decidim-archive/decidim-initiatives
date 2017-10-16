# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe InitiativeHelper do
      context 'state_badge_css_class' do
        let(:initiative) { create(:initiative) }

        it 'success for accepted initiatives' do
          allow(initiative).to receive(:accepted?).and_return(true)

          expect(helper.state_badge_css_class(initiative)).to eq('success')
        end

        it 'warning in any other case' do
          allow(initiative).to receive(:accepted?).and_return(false)

          expect(helper.state_badge_css_class(initiative)).to eq('warning')
        end
      end

      context 'humanize_state' do
        let(:initiative) { create(:initiative) }

        it 'accepted for accepted state' do
          allow(initiative).to receive(:accepted?).and_return(true)

          expect(helper.humanize_state(initiative)).to eq(I18n.t('accepted', scope: 'decidim.initiatives.states'))
        end

        it 'expired in any other case' do
          allow(initiative).to receive(:accepted?).and_return(false)

          expect(helper.humanize_state(initiative)).to eq(I18n.t('expired', scope: 'decidim.initiatives.states'))
        end
      end
    end
  end
end
