# frozen_string_literal: true

module Decidim
  module Initiatives
    # A command with all the business logic that creates a new initiative.
    class CreateInitiative < Rectify::Command
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      # current_user - Current user.
      def initialize(form, current_user)
        @form = form
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?
        initiative = create_initiative

        if initiative.persisted?
          broadcast(:ok, initiative)
        else
          broadcast(:invalid)
        end
      end

      private

      attr_reader :form, :current_user

      def create_initiative
        initiative = build_initiative
        return initiative unless initiative.valid?

        initiative.save
        initiative
      end

      def build_initiative
        Initiative.new(
          organization: form.current_organization,
          title: { current_locale => form.title },
          description: { current_locale => form.description },
          author: current_user,
          decidim_user_group_id: form.decidim_user_group_id,
          type_id: form.type_id,
          decidim_scope_id: form.scope_id,
          signature_type: form.signature_type,
          state: 'created'
        )
      end

      # The current locale for the user. Available as a helper for the views.
      #
      # Returns a String.
      def current_locale
        @current_locale ||= I18n.locale.to_s
      end
    end
  end
end
