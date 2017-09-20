# frozen_string_literal: true

module Decidim
  module Initiatives
    module InitiativesHelper
      include PaginateHelper
      include InitiativeVotesHelper
      include Decidim::Comments::CommentsHelper

      # Public: The css class applied based on the initiative state to
      #         the initiative badge.
      #
      # state - The String state of the proposal.
      #
      # Returns a String.
      def state_badge_css_class(state)
        case state
          when "accepted"
            "success"
          when "rejected"
            "warning"
          when "created"
            "secondary"
        end
      end

      # Public: The state of a initiative in a way a human can understand.
      #
      # state - The String state of the initiative.
      #
      # Returns a String.
      def humanize_state(state)
        I18n.t(state, scope: "decidim.initiatives.states", default: :created)
      end

      def creation_enabled?
        Decidim::Initiatives.creation_enabled
      end
    end
  end
end
