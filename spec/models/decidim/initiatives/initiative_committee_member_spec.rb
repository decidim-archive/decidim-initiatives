# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe InitiativesCommitteeMember do
      let(:committee_member) { build(:initiatives_committee_member) }

      it 'is valid' do
        expect(committee_member).to be_valid
      end
    end
  end
end
