# frozen_string_literal: true

module Decidim
  module Initiatives
    class InitiativeWidgetsController < Decidim::WidgetsController
      helper InitiativesHelper

      private

      def model
        @model ||= Initiative.find(params[:initiative_id])
      end

      def current_participatory_space
        model
      end

      def iframe_url
        @iframe_url ||= initiative_initiative_widget_url(model)
      end
    end
  end
end
