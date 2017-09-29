# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe InitiativesType do
      let(:initiatives_type) { build :initiatives_type }
      subject { initiatives_type }

      it { is_expected.to be_valid }
    end
  end
end
