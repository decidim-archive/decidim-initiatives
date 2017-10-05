# frozen_string_literal: true

module Decidim
  module Initiatives
    module Abilities
      module Admin
        # Defines the abilities related to user able to administer attachments
        # for an initiative.
        # Intended to be used with `cancancan`.
        class AttachmentsAbility
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

            can :read, Decidim::Attachment
            can :create, Decidim::Attachment
            can :update, Decidim::Attachment do |attachment|
              attachment.attached_to.author.id == user.id
            end
            can :destroy, Decidim::Attachment do |attachment|
              attachment.attached_to.author.id == user.id
            end
          end

          def admin?
            user&.admin?
          end
        end
      end
    end
  end
end
