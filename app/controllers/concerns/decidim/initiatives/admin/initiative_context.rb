# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # This module, when injected into a controller, ensures there's a
      # Initiative available and deducts it from the context.
      module InitiativeContext
        def self.extended(base)
          base.class_eval do
            include InitiativeAdmin

            delegate :active_step, to: :current_initiative, prefix: false

            alias_method :current_initiative, :current_participatory_space
          end
        end
      end
    end
  end
end
