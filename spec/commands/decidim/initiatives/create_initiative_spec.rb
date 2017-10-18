# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe CreateInitiative do
      let(:form_klass) { InitiativeForm }

      it_behaves_like 'create an initiative'
    end
  end
end