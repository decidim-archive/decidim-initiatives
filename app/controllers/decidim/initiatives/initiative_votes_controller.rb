# frozen_string_literal: true

module Decidim
  module Initiatives
    # Exposes the initiative vote resource so users can vote initiatives.
    class InitiativeVotesController < Decidim::ApplicationController
      helper_method :initiative

      before_action :authenticate_user!

      helper Decidim::ActionAuthorizationHelper
      include Decidim::Initiatives::ActionAuthorization

      include Votable

      def create
        authorize! :vote, initiative
        @from_initiatives_list = params[:from_initiatives_list] == "true"

        VoteInitiative.call(initiative, current_user) do
          on(:ok) do
            initiative.reload
            render :update_buttons_and_counters
          end

          on(:invalid) do
            render json: { error: I18n.t("initiative_votes.create.error", scope: "decidim.initiatives") }, status: 422
          end
        end
      end

      def destroy
        authorize! :unvote, initiative
        @from_initiatives_list = params[:from_initiatives_list] == "true"

        UnvoteInitiative.call(initiative, current_user) do
          on(:ok) do
            initiative.reload
            render :update_buttons_and_counters
          end
        end
      end

      private

      def initiative
        @initiative ||= Initiative.find(params[:initiative_id])
      end
    end
  end
end
