# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe UpdateInitiative do
        let(:form_klass) { Decidim::Initiatives::Admin::InitiativeForm }

        it_behaves_like 'update an initiative'
      end
    end
  end
end