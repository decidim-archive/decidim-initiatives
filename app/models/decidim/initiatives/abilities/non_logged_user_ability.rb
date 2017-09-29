# frozen_string_literal: true

module Decidim
  module Initiatives
    module Abilities
      # Defines the abilities for non logged users..
      # Intended to be used with `cancancan`.
      class NonLoggedUserAbility
        include CanCan::Ability

        attr_reader :context

        def initialize(user, context)
          return if user

          @context = context

          can :vote, Initiative
        end
      end
    end
  end
end
