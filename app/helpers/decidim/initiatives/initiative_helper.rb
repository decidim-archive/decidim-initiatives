# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper method related to initiative object and its internal state.
    module InitiativeHelper
      # Public: The css class applied based on the initiative state to
      #         the initiative badge.
      #
      # initiative - Decidim::Initiative
      #
      # Returns a String.
      def state_badge_css_class(initiative)
        return 'warning' if initiative.closed?
        'success'
      end

      # Public: The state of an initiative in a way a human can understand.
      #
      # initiative - Decidim::Initiative.
      #
      # Returns a String.
      def humanize_state(initiative)
        I18n.t(initiative.closed? ? 'closed': 'open', scope: 'decidim.initiatives.states', default: :open)
      end

      # Public: The state of an initiative from an administration perspective in
      # a way that a human can understand.
      #
      # state - String
      #
      # Returns a String
      def humanize_admin_state(state)
        I18n.t(state, scope: 'decidim.initiatives.admin_states', default: :created)
      end
    end
  end
end
