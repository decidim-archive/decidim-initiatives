# frozen_string_literal: true

module Decidim
  module Initiatives
    # This controller contains the logic regarding citizen initiatives
    class InitiativesController < Decidim::ApplicationController
      layout 'layouts/decidim/initiative', only: [:show]

      before_action :set_initiative, only: [:show]

      helper Decidim::WidgetUrlsHelper
      helper Decidim::FiltersHelper
      helper Decidim::OrdersHelper
      helper Decidim::ActionAuthorizationHelper

      include Decidim::Initiatives::ActionAuthorization
      include FilterResource
      include Paginable
      include Orderable
      include TypeSelectorOptions
      include Votable

      helper_method :collection, :initiatives, :filter

      # GET /initiatives
      def index
        authorize! :read, Initiative
      end

      def show
        authorize! :read, Initiative
      end

      private

      def set_initiative
        @initiative = Initiative.find(params[:id])
      end

      def initiatives
        @initiatives = search.results.includes(:author)
        @initiatives = paginate(@initiatives)
        @initiatives = reorder(@initiatives)
      end

      alias collection initiatives

      def search_klass
        InitiativeSearch
      end

      def default_filter_params
        {
          search_text: '',
          state: 'open',
          type: 'all',
          author: 'any'
        }
      end

      def context_params
        {
          organization: current_organization,
          current_user: current_user
        }
      end
    end
  end
end
