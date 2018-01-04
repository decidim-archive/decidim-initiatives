# frozen_string_literal: true

module Decidim
  module Initiatives
    # This module, when injected into a controller, ensures there is an
    # Initiative available and deducts it from the context.
    module InitiativeContext
      def self.extended(base)
        base.class_eval do
          include NeedsInitiative

          layout 'layouts/decidim/initiative'

          before_action do
            authorize! :read, current_initiative
          end
        end
      end

      def ability_context
        super.merge(current_assembly: current_initiative)
      end
    end
  end
end
