# frozen_string_literal: true

module Decidim
  module Initiatives
    # This controller contains the logic regarding citizen initiatives
    class InitiativesController < Decidim::ApplicationController
      layout 'layouts/decidim/initiative', only: [:show]

      helper Decidim::WidgetUrlsHelper
      helper Decidim::AttachmentsHelper
      helper Decidim::FiltersHelper
      helper Decidim::OrdersHelper
      helper Decidim::ActionAuthorizationHelper
      helper Decidim::PartialTranslationsHelper
      helper Decidim::ResourceHelper
      helper Decidim::IconHelper
      helper Decidim::Comments::CommentsHelper
      helper Decidim::Admin::IconLinkHelper
      helper PaginateHelper
      helper InitiativeHelper

      include Decidim::Initiatives::ActionAuthorization
      include FilterResource
      include Paginable
      include Orderable
      include TypeSelectorOptions
      include NeedsInitiative

      helper_method :collection, :initiatives, :filter, :stats

      skip_authorization_check only: :signature_identities

      # GET /initiatives
      def index
        authorize! :read, Initiative
      end

      # GET /initiatives/:id
      def show
        authorize! :read, current_initiative
      end

      # GET /initiatives/:id/signature_identities
      def signature_identities
        @voted_groups = InitiativesVote
                        .supports
                        .where(initiative: current_initiative, author: current_user)
                        .pluck(:decidim_user_group_id)
        render layout: false
      end

      private

      def initiatives
        @initiatives = search.results.includes(:author, :scoped_type)
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

      def stats
        @stats ||= InitiativeStatsPresenter.new(initiative: current_initiative)
      end
    end
  end
end
