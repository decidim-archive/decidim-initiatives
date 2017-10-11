# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe Initiative do
      context 'published initiative' do
        let(:published_initiative) { build :initiative }

        it 'is valid' do
          expect(published_initiative).to be_valid
        end

        it 'unpublish!' do
          published_initiative.unpublish!

          expect(published_initiative).to be_discarded
          expect(published_initiative.published_at).to be_nil
        end

        it 'signature_interval_defined?' do
          expect(published_initiative).to have_signature_interval_defined
        end
      end

      context 'validating initiative' do
        let(:validating_initiative) {
          build(:initiative,
                state: 'validating',
                published_at: nil,
                signature_start_time: nil,
                signature_end_time: nil)
        }

        it 'is valid' do
          expect(validating_initiative).to be_valid
        end

        it 'publish!' do
          validating_initiative.publish!
          expect(validating_initiative).to have_signature_interval_defined
          expect(validating_initiative.published_at).not_to be_nil
        end
      end
    end
  end
end
