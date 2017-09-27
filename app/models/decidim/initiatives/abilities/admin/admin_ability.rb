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

            can :manage, Initiative

            can :manage, InitiativesType
            cannot :destroy, InitiativesType
            can :destroy, InitiativesType do |initiative_type|
              initiative_type.initiatives.empty?
            end
          end
        end
      end
    end
  end
end
