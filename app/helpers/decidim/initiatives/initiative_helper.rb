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
        return 'success' if initiative.accepted?
        'warning'
      end

      # Public: The state of an initiative in a way a human can understand.
      #
      # initiative - Decidim::Initiative.
      #
      # Returns a String.
      def humanize_state(initiative)
        I18n.t(initiative.accepted? ? 'accepted': 'expired', scope: 'decidim.initiatives.states', default: :expired)
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

      def popularity_tag(initiative)
        popularity_class = ''

        if initiative.percentage > 0 && initiative.percentage < 40
          popularity_class = 'popularity--level1'
        end

        if initiative.percentage >= 40 && initiative.percentage < 60
          popularity_class = 'popularity--level2'
        end

        if initiative.percentage >= 60 && initiative.percentage < 80
          popularity_class = 'popularity--level3'
        end

        if initiative.percentage >= 80 && initiative.percentage < 100
          popularity_class = 'popularity--level4'
        end

        if initiative.percentage >= 100
          popularity_class = 'popularity--level5'
        end

        content_tag(:div, class: "extra__popularity popularity #{popularity_class}".strip) do
          5.times do
            concat(content_tag(:span, class: 'popularity__item') {})
          end

          concat(content_tag(:span, class: 'popularity__desc') do
            I18n.t('decidim.initiatives.initiatives.vote_cabin.supports_required', total_supports: initiative.scoped_type.supports_required)
          end)
        end
      end
    end
  end
end
