# frozen_string_literal: true

module Decidim
  module Initiatives
    # Controller in charge of managing committee membership
    class CommitteeRequestsController < Decidim::ApplicationController
      helper Decidim::ActionAuthorizationHelper
      helper_method :initiatives_committee_member, :current_initiative

      include Decidim::Initiatives::ActionAuthorization

      def new
        authorize! :request_membership, current_initiative
      end

      def spawn
        authorize! :request_membership, current_initiative

        SpawnCommitteeRequest.call(current_initiative, current_user) do
          on(:ok) do
            redirect_to initiatives_path, flash: {
              notice: I18n.t(
                '.success',
                scope: %w[decidim initiatives committee_requests spawn]
              )
            }
          end

          on(:invalid) do |request|
            redirect_to initiatives_path, flash: {
              error: request.errors.full_messages.to_sentence
            }
          end
        end
      end

      private

      def initiatives_committee_member
        @initiatives_committee_member ||= InitiativesCommitteeMember
                                          .find(params[:id])
      end

      def current_initiative
        @current_initiative ||= Decidim::Initiative.find(params[:initiative_id])
      end
    end
  end
end
