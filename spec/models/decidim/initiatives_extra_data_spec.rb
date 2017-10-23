# frozen_string_literal: true

require 'spec_helper'

module Decidim
  describe InitiativesExtraData do
    let(:extra_data) { build(:initiatives_extra_data, :author) }

    it 'is valid' do
      expect(extra_data).to be_valid
    end
  end
end
