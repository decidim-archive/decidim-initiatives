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
      include Decidim::Initiatives::Scopeable

      helper Decidim::PartialTranslationsHelper
      helper_method :similar_initiatives

      steps :select_initiative_type,
            :previous_form,
            :show_similar_initiatives,
            :fill_data,
            :create_initiative

      def show
        authorize! :create, Initiative
        send("#{step}_step", initiative: session[:initiative])
      end

      def update
        authorize! :create, Initiative
        send("#{step}_step", params)
      end

      private

      def select_initiative_type_step(_unused)
        @form = form(Decidim::Initiatives::SelectInitiativeTypeForm).instance
        session[:initiative] = {}
        render_wizard
      end

      def previous_form_step(parameters)
        @form = build_form(Decidim::Initiatives::PreviousForm, parameters)
        render_wizard
      end

      def show_similar_initiatives_step(parameters)
        @form = build_form(Decidim::Initiatives::PreviousForm, parameters)
        unless @form.valid?
          redirect_to previous_wizard_path(validate_form: true)
          return
        end

        if similar_initiatives.empty?
          @form = build_form(Decidim::Initiatives::InitiativeForm, parameters)
          redirect_to wizard_path(:fill_data)
        end

        render_wizard unless performed?
      end

      def fill_data_step(parameters)
        @form = build_form(Decidim::Initiatives::InitiativeForm, parameters)
        render_wizard
      end

      def create_initiative_step(parameters)
        @form = build_form(Decidim::Initiatives::InitiativeForm, parameters)

        CreateInitiative.call(@form, current_user) do
          on(:ok) do |initiative|
            redirect_to decidim_admin_initiatives.edit_initiative_path(initiative)
          end

          on(:invalid) do |initiative|
            redirect_to previous_wizard_path(validate_form: true)
          end
        end
      end

      def similar_initiatives
        @similar_initiatives ||= Decidim::Initiatives::SimilarInitiatives
                                 .for(current_organization, @form)
                                 .all
      end

      def build_form(klass, parameters)
        @form = form(klass).from_params(parameters)
        attributes = @form.attributes_with_values
        session[:initiative] = session[:initiative].merge(attributes)
        @form.valid? if params[:validate_form]

        @form
      end
    end
  end
end
