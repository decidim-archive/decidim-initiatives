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

            can :preview, Initiative

            define_user_abilities
            define_admin_abilities
          end

          def define_admin_abilities
            return unless admin?

            can :manage, Initiative
            cannot :send_to_technical_validation, Initiative
            cannot :show, Initiative
            can :show, Initiative do |_initiative|
              Decidim::Initiatives.print_enabled
            end

            cannot :publish, Initiative
            can :publish, Initiative, &:validating?

            cannot :unpublish, Initiative
            can :unpublish, Initiative, &:published?

            cannot :discard, Initiative
            can :discard, Initiative, &:validating?

            cannot :export_votes, Initiative
            can :export_votes, Initiative do |initiative|
              initiative.offline? || initiative.any?
            end

            can :manage, InitiativesType
            cannot :destroy, InitiativesType
            can :destroy, InitiativesType do |initiative_type|
              result = true

              initiative_type.scopes.each do |s|
                result &&= s.initiatives.empty?
              end

              result
            end

            can :manage, Decidim::InitiativesTypeScope
            cannot :destroy, Decidim::InitiativesTypeScope
            can :destroy, Decidim::InitiativesTypeScope do |scope|
              scope.initiatives.empty?
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

            can :show, Initiative do |initiative|
              initiative.has_authorship?(user) && Decidim::Initiatives.print_enabled
            end

            can :edit, Decidim::Initiative do |initiative|
              initiative.has_authorship?(user)
            end

            can :update, Decidim::Initiative do |initiative|
              initiative.has_authorship?(user) && initiative.created?
            end

            can :manage_membership, Decidim::Initiative do |initiative|
              initiative.has_authorship?(user)
            end

            can :index, InitiativesCommitteeMember
            can :approve, InitiativesCommitteeMember do |request|
              request.initiative.has_authorship?(user) && !request.initiative.published? && !request.accepted?
            end

            can :revoke, InitiativesCommitteeMember do |request|
              request.initiative.has_authorship?(user) && !request.initiative.published? && !request.rejected?
            end

            can :send_to_technical_validation, Initiative do |initiative|
              initiative.has_authorship?(user) &&
                initiative.created? &&
                (
                !initiative.decidim_user_group_id.nil? ||
                  initiative.committee_members.approved.count >= Decidim::Initiatives.minimum_committee_members
                )
            end
          end

          private

          def has_initiatives?(user)
            initiatives = InitiativesCreated.by(user) | InitiativesPromoted.by(user)
            initiatives.any?
          end

          def admin?
            user&.admin?
          end
        end
      end
    end
  end
end
