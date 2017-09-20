# frozen_string_literal: true
module Decidim
  module Initiatives
    require 'wicked'

    # Controller in charge of managing the create initiative wizard.
    class CreateInitiativeController < Decidim::ApplicationController
      include Wicked::Wizard
      include TypeSelectorOptions

      steps :select_initiative_type, :fill_description, :show_similar_initiatives, :fill_data, :create_initiative

      def show
        authorize! :create, Initiative
      # session[:initiative] = Initiative.new().attributes
        render_wizard
      end

      def update
        authorize! :create, Initiative
        render_wizard
      end

      #
      # private


    end
  end
end
