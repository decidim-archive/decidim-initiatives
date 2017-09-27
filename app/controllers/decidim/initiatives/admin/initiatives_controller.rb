# frozen_string_literal: true

require_dependency 'decidim/initiatives/admin/application_controller'

module Decidim
  module Initiatives
    module Admin
      # Controller used to manage the initiatives
      class InitiativesController < ApplicationController
        helper_method :current_initiative

        helper Decidim::Initiatives::InitiativeHelper

        def index
          authorize! :index, Decidim::Initiative
          @initiatives = ActionPendingInitiatives.for(current_organization)
        end

        def edit
          authorize! :edit, current_initiative
          @form = form(Decidim::Initiatives::Admin::InitiativeForm)
                  .from_model(current_initiative)
        end

        def update
          authorize! :update, current_initiative
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
      end
    end
  end
end
