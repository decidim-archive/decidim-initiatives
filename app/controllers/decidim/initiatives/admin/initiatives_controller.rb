# frozen_string_literal: true

require_dependency 'decidim/initiatives/admin/application_controller'

module Decidim
  module Initiatives
    module Admin
      # Controller used to manage the initiatives
      class InitiativesController < ApplicationController
        helper_method :current_initiative, :initiative_type_options

        include Decidim::Initiatives::Scopeable

        helper Decidim::Initiatives::InitiativeHelper
        helper Decidim::Initiatives::CreateInitiativeHelper
        helper Decidim::PartialTranslationsHelper

        def index
          authorize! :index, Decidim::Initiative
          @initiatives = ActionPendingInitiatives
                           .for(current_organization, current_user)
                           .page(params[:page])
                           .per(15)
        end

        def edit
          authorize! :edit, current_initiative
          @form = form(Decidim::Initiatives::Admin::InitiativeForm)
                  .from_model(current_initiative)

          render layout: 'decidim/admin/initiative'
        end

        def update
          authorize! :update, current_initiative

          @form = form(Decidim::Initiatives::Admin::InitiativeForm).from_params(params)
          UpdateInitiative.call(current_initiative, @form) do
            on(:ok) do |initiative|
              render :edit, layout: 'decidim/admin/initiative'
            end

            on(:invalid) do |initiative|
              render :edit, layout: 'decidim/admin/initiative'
            end
          end
        end

        def validate
          authorize! :technically_validate, current_initiative
          current_initiative.validated!
          redirect_to decidim_admin_initiatives.initiatives_path
        end

        def discard
          authorize! :technically_validate, current_initiative
          current_initiative.discarded!
          redirect_to decidim_admin_initiatives.initiatives_path
        end

        def request_changes
          authorize! :technically_validate, current_initiative
          current_initiative.created!
          redirect_to decidim_admin_initiatives.initiatives_path
        end

        private

        def current_initiative
          @initiative ||= Initiative.find(params[:id])
        end

        def initiative_type_options
          InitiativesType.where(organization: current_organization).map do |type|
            [type.title[I18n.locale.to_s], type.id]
          end
        end
      end
    end
  end
end
