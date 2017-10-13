module Decidim
  module Initiatives
    class InitiativesMailer < ApplicationMailer
      after_action :prevent_delivery_to_users_without_email

      # Notify progress to all initiative subscribers.
      def notify_progress(initiative)
        #TODO
      end

      # Notify changes in state. Depending on the state the target
      # group may change.
      def notify_state_change(initiative)
        #TODO
      end

      private

      def with_user(user, &block)
        I18n.with_locale(user.locale) do
          yield
        end
      end

      def prevent_delivery_to_users_without_email
        mail.perform_deliveries = !@email_to.blank?
      end
    end
  end
end
