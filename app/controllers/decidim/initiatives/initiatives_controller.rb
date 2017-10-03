# frozen_string_literal: true

module Decidim
  module Initiatives
    # This controller contains the logic regarding citizen initiatives
    class InitiativesController < Decidim::ApplicationController
      layout 'layouts/decidim/initiative', only: [:show]

      helper Decidim::WidgetUrlsHelper
      helper Decidim::FiltersHelper
      helper Decidim::OrdersHelper
      helper Decidim::ActionAuthorizationHelper
      helper Decidim::PartialTranslationsHelper
      helper Decidim::ResourceHelper

      include Decidim::Initiatives::ActionAuthorization
      include FilterResource
      include Paginable
      include Orderable
      include TypeSelectorOptions
      include Decidim::Initiatives::Scopeable

      helper_method :collection, :initiatives, :filter, :initiative

      skip_authorization_check only: :signature_identities

      # GET /initiatives
      def index
        authorize! :read, Initiative
      end

      def show
        authorize! :read, initiative
      end

      def send_to_technical_validation
        authorize! :send_to_technical_validation, initiative
        initiative.validating!
        redirect_to initiative_path(initiative), flash: {
          notice: I18n.t(
            '.success',
            scope: %w[
              decidim initiatives initiatives technical_validation
            ]
          )
        }
      end

      def signature_identities
        @voted_groups = InitiativesVote
                          .supports
                          .where(initiative: initiative, author: current_user)
                          .pluck(:decidim_user_group_id)
        render layout: false
      end

      private

      def initiative
        @initiative ||= Initiative.find(params[:id])
      end

      def initiatives
        @initiatives = search.results.includes(:author, :type)
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
          author: 'any',
          scope_id: nil
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
