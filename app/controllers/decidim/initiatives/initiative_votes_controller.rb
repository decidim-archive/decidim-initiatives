# frozen_string_literal: true

module Decidim
  module Initiatives
    # Exposes the initiative vote resource so users can vote initiatives.
    class InitiativeVotesController < Decidim::ApplicationController
      helper_method :initiative

      before_action :authenticate_user!

      helper Decidim::ActionAuthorizationHelper
      helper InitiativeHelper
      include Decidim::Initiatives::ActionAuthorization

      def create
        authorize! :vote, initiative
        VoteInitiative.call(initiative, current_user, params[:group_id]) do
          on(:ok) do
            initiative.reload
            render :update_buttons_and_counters
          end

          on(:invalid) do
            render json: { error: I18n.t('initiative_votes.create.error', scope: 'decidim.initiatives') }, status: 422
          end
        end
      end

      def destroy
        authorize! :unvote, initiative
        UnvoteInitiative.call(initiative, current_user, params[:group_id]) do
          on(:ok) do
            initiative.reload
            render :update_buttons_and_counters
          end
        end
      end

      private

      def ability_context
        {
          current_settings: try(:current_settings),
          feature_settings: try(:feature_settings),
          current_organization: try(:current_organization),
          current_feature: try(:current_feature),
          params: try(:params)
        }
      end

      def initiative
        @initiative ||= Initiative.find(params[:initiative_id])
      end
    end
  end
end
