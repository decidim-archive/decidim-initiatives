# frozen_string_literal: true

module Decidim
  module Initiatives
    module Abilities
      module Admin
        # Defines the abilities related to initiatives for an administrator user
        # Intended to be used with `cancancan`.
        class AdminAbility < Decidim::Abilities::AdminAbility
          def define_abilities
            super

            can :aprove, Initiative
            can :manage, InitiativeType
          end
        end
      end
    end
  end
end
