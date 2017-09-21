# frozen_string_literal: true
module Decidim
  module Initiatives
    require 'wicked'

    # Controller in charge of managing the create initiative wizard.
    class CreateInitiativeController < Decidim::ApplicationController
      include Wicked::Wizard
      include Decidim::FormFactory
      include InitiativeHelper
      include TypeSelectorOptions

      helper_method :similar_initiatives

      steps :select_initiative_type, :previous_form, :show_similar_initiatives, :fill_data, :create_initiative

      def show
        authorize! :create, Initiative
        send("#{step}_step", { initiative: session[:initiative] })
        render_wizard @form
      end

      def update
        authorize! :create, Initiative
        send("#{step}_step", params)
        render_wizard @form unless performed?
      end

      private

      def select_initiative_type_step(parameters)
        @form = form(Decidim::Initiatives::SelectInitiativeTypeForm).instance
        session[:initiative] = {}
      end

      def previous_form_step(parameters)
        @form = form(Decidim::Initiatives::PreviousForm).from_params(parameters)
        session[:initiative] = session[:initiative].merge(@form.attributes_with_values)
      end

      def show_similar_initiatives_step(parameters)
        @form = form(Decidim::Initiatives::PreviousForm).from_params(parameters)
        session[:initiative] = session[:initiative].merge(@form.attributes_with_values)

        if @form.valid?
          if similar_initiatives.empty?
            @form = form(Decidim::Initiatives::InitiativeForm).from_params(parameters)
            skip_step
          end
        else
          redirect_to previous_wizard_path
        end
      end

      def fill_data_step(parameters)
        @form = form(Decidim::Initiatives::InitiativeForm).from_params(parameters)
        session[:initiative] = session[:initiative].merge(@form.attributes_with_values)
      end

      def create_initiative_step(parameters)
        @form = form(Decidim::Initiatives::InitiativeForm).from_params(parameters)
        session[:initiative] = session[:initiative].merge(@form.attributes_with_values)

        CreateInitiative.call(@form) do
          on(:ok) do |initiative|
            redirect_to initiative_path(initiative)
          end

          on(:invalid) do
            redirect_to previous_wizard_path
          end
        end
      end

      def similar_initiatives
        @similar_initiatives ||= Decidim::Initiatives::SimilarInitiatives.for(current_organization, @form).all
      end
    end
  end
end
