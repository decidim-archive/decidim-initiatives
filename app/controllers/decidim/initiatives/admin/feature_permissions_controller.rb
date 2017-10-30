# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # Controller that allows managing the Initiative's Feature
      # permissions in the admin panel.
      class FeaturePermissionsController < Decidim::Admin::FeaturePermissionsController
        include InitiativeAdmin
      end
    end
  end
end
