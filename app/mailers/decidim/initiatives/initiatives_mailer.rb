# frozen_string_literal: true

module Decidim
  module Initiatives
    # Mailer for initiatives engine.
    class InitiativesMailer < Decidim::ApplicationMailer
      # Notify progress to all initiative subscribers.
      def notify_progress(initiative)
        initiative.followers.each do |follower|
          with_user(follower) do
            # TODO Define body, subject and view for this mailer
            @subject = ''
            @body = ''

            mail(to: "#{user.name} <#{user.email}>", subject: @subject)
          end
        end
      end

      # Notify changes in state. Depending on the state the target
      # group may change.
      def notify_state_change(initiative)
        validating_initiative(initiative)if initiative.validating?

        if initiative.published? || initiative.discarded?
          validating_result(initiative)
        end

        if initiative.rejected? || initiative.accepted?
          voting_result(initiative)
        end
      end

      private

      def validating_initiative(initiative)
        initiative.organization.admins.each do |user|
          with_user(user) do
            # TODO Define body, subject and view for this mailer
            @subject = ''
            @body = ''

            mail(to: "#{user.name} <#{user.email}>", subject: @subject)
          end
        end
      end

      def validating_result(initiative)
        with_user(initiative.author) do
          # TODO Define body, subject and view for this mailer
          @subject = ''
          @body = ''

          mail(to: "#{initiative.author.name} <#{initiative.author.email}>", subject: @subject)
        end
      end

      def voting_result(initiative)
        initiative.followers.each do |follower|
          with_user(follower) do
            # TODO Define body, subject and view for this mailer
            @subject = ''
            @body = ''

            mail(to: "#{user.name} <#{user.email}>", subject: @subject)
          end
        end
      end
    end
  end
end
