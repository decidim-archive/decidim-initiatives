# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe UpdateInitiativeType do
        let(:form_klass) { InitiativeTypeForm }

        it_behaves_like 'update an initiative type', true
      end
    end
  end
end