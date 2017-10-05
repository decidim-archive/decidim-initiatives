# frozen_string_literal: true

module Decidim
  module Initiatives
    module Abilities
      module Admin
        # Defines the abilities related to user able to administer initiatives.
        # Intended to be used with `cancancan`.
        class InitiativeAdminAbility
          include CanCan::Ability

          attr_reader :user, :context

          def initialize(user, context)
            return unless user

            @user = user
            @context = context

            define_user_abilities
            define_admin_abilities
          end

          def define_admin_abilities
            return unless admin?

            can :manage, Initiative
            can :manage, InitiativesType
            cannot :destroy, InitiativesType
            can :destroy, InitiativesType do |initiative_type|
              initiative_type.initiatives.empty?
            end

            can :manage_membership, Decidim::Initiative
            can :index, InitiativesCommitteeMember

            can :approve, InitiativesCommitteeMember do |request|
              !request.accepted?
            end

            can :revoke, InitiativesCommitteeMember do |request|
              !request.rejected?
            end
          end

          def define_user_abilities
            return if admin?

            can :read, :admin_dashboard do
              has_initiatives?(user)
            end

            can :index, Decidim::Initiative do
              has_initiatives?(user)
            end

            can :edit, Decidim::Initiative do |initiative|
              initiative.author.id == user.id
            end

            can :update, Decidim::Initiative  do |initiative|
              initiative.author.id == user.id && !initiative.published?
            end

            can :manage_membership, Decidim::Initiative do |initiative|
              initiative.author.id == user.id
            end

            can :index, InitiativesCommitteeMember
            can :approve, InitiativesCommitteeMember do |request|
              request.initiative.author.id == user.id && !request.initiative.published? && !request.accepted?
            end
            can :revoke, InitiativesCommitteeMember do |request|
              request.initiative.author.id == user.id && !request.initiative.published? && !request.rejected?
            end
          end

          private

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
