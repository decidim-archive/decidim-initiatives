# frozen_string_literal: true

module Decidim
  module Initiatives
    module Abilities
      # Defines the abilities related to initiatives for a logged in user.
      # Intended to be used with `cancancan`.
      class CurrentUserAbility
        include CanCan::Ability

        attr_reader :user, :context

        def initialize(user, context)
          return unless user

          @user = user
          @context = context

          can :vote, Initiative do |initiative|
            can_vote?(user, initiative)
          end

          can :unvote, Initiative do |initiative|
            can_vote?(initiative)
          end

          can :create, Initiative if creation_enabled?
        end

        private

        def creation_enabled?
          Decidim::Initiatives.creation_enabled && user.authorizations.any?
        end

        def can_vote?(initiative)
          initiative.votes_enabled? &&
            initiative.organization&.id == user.organization&.id &&
            user.authorizations.any?
        end
      end
    end
  end
end
