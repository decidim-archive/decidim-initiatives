# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # Controller that allows managing the Initiative's Features in the
      # admin panel.
      class FeaturesController < Decidim::Admin::FeaturesController
        layout "decidim/admin/initiative"

        include NeedsInitiative
      end
    end
  end
end
