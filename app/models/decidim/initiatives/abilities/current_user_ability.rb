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

          can :create, Initiative if creation_enabled?
          can :read, Initiative do |initiative|
            initiative.published? || initiative.decidim_author_id == user.id
          end

          define_vote_abilities
          define_membership_management_abilities

          can :send_to_technical_validation, Initiative do |initiative|
            initiative.decidim_author_id == user.id && initiative.created?
          end
        end

        private

        def creation_enabled?

          Decidim::Initiatives.creation_enabled && (
            user.authorizations.any? || user.user_groups.verified.any?
          )
        end

        def define_vote_abilities
          can :vote, Initiative do |initiative|
            can_vote?(initiative)
          end

          can :unvote, Initiative do |initiative|
            can_vote?(initiative)
          end
        end

        def define_membership_management_abilities
          can :request_membership, Initiative do |initiative|
            !initiative.published? && initiative.decidim_author_id != user.id
          end

          can :manage_membership, InitiativesCommitteeMember do |request|
            request.initiative.decidim_author_id == user.id
          end
        end

        def can_vote?(initiative)
          initiative.votes_enabled? &&
            initiative.organization&.id == user.organization&.id && (
              user.authorizations.any? || user.user_groups.verified.any?
            )
        end
      end
    end
  end
end
