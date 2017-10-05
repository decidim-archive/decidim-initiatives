# frozen_string_literal: true

module Decidim
  module Initiatives
    module Abilities
      module Admin
        # Defines the abilities related to user able to administer features
        # for an initiative.
        # Intended to be used with `cancancan`.
        class FeaturesAbility
          include CanCan::Ability

          attr_reader :user, :context

          def initialize(user, context)
            return unless user

            @user = user
            @context = context

            define_abilities
          end

          private

          def define_abilities
            return if admin?

            can :read, Decidim::Feature do
              has_initiatives?(user)
            end

            can :update, Decidim::Feature do |feature|
              feature.participatory_space.author.id == user.id
            end
          end

          def has_initiatives?(user)
            Initiative.where(author: user).any?
          end

          def admin?
            user&.admin?
          end
        end
      end
    end
  end
end
