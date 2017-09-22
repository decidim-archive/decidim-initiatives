# frozen_string_literal: true

require_dependency 'decidim/initiatives/admin/application_controller'

module Decidim
  module Initiatives
    module Admin
      # Controller used to manage the available initiative types for the current
      # organization.
      class InitiativesTypesController < ApplicationController
        def index
          authorize! :index, Decidim::InitiativesType
        end

        def new
          authorize! :new, Decidim::InitiativesType
        end

        def create
          authorize! :create, Decidim::InitiativesType
        end

        def edit
          authorize! :edit, Decidim::InitiativesType
        end

        def update
          authorize! :update, Decidim::InitiativesType
        end

        def destroy
          authorize! :destroy, Decidim::InitiativesType
        end
      end
    end
  end
end
