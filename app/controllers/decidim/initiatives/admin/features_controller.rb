# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # Controller that allows managing the Initiative's Features in the
      # admin panel.
      #
      class FeaturesController < Decidim::Admin::FeaturesController
        layout 'decidim/admin/initiative'

        helper Decidim::PartialTranslationsHelper
        helper_method :current_initiative

        private

        def current_initiative
          @initiative ||= Initiative.find(params[:initiative_id])
        end

        alias_method :current_participatory_space, :current_initiative
      end
    end
  end
end