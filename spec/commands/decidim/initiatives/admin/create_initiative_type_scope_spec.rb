# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe CreateInitiativeTypeScope do
        let(:form_klass) { InitiativeTypeScopeForm }

        it_behaves_like 'create an initiative type scope'
      end
    end
  end
end