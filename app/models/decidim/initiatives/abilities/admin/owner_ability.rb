# frozen_string_literal: true

module Decidim
  module Initiatives
    module Abilities
      module Admin
        # Defines the administration abilities related to initiative's owner.
        # Intended to be used with `cancancan`.
        class OwnerAbility
          include CanCan::Ability

          attr_reader :user, :context

          def initialize(user, context)
            return unless user

            @user = user
            @context = context

            can :publish, Initiative do |initiative|
              initiative.author.id == user.id
            end
          end
        end
      end
    end
  end
end
