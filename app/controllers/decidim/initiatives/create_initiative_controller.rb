# frozen_string_literal: true

module Decidim
  module Initiatives
    # Controller in charge of managing the create initiative wizard.
    class CreateInitiativeController < Decidim::ApplicationController
      include Wicked::Wizard

      steps :select_initiative_type, :fill_description, :show_similar_initiatives, :fill_data, :create_initiative

      def show
        # session[:initiative] = Initiative.new().attributes
        render_wizard
      end

      private


    end
  end
end
