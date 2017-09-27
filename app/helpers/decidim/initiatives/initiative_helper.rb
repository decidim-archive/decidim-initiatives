# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper method related to initiative object and its internal state.
    module InitiativeHelper
      # Public: The css class applied based on the initiative state to
      #         the initiative badge.
      #
      # state - The String state of the proposal.
      #
      # Returns a String.
      def state_badge_css_class(state)
        case state
        when 'created', 'validated', 'publishing', 'published', 'accepted'
          'success'
        when 'discarded', 'rejected'
          'warning'
        when 'validating'
          'secondary'
        end
      end

      # Public: The state of a initiative in a way a human can understand.
      #
      # state - The String state of the initiative.
      #
      # Returns a String.
      def humanize_state(state)
        I18n.t(state, scope: 'decidim.initiatives.states', default: :created)
      end
    end
  end
end
