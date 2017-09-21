# frozen_string_literal: true

module Decidim
  module Initiatives
    # A command with all the business logic that creates a new initiative.
    class CreateInitiative < Rectify::Command
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      def initialize(form)
        @form = form
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

      attr_reader :form

      def create_initiative
        initiative = Initiative.new(
          organization: form.current_organization,
          author: form.current_user,
          title: form.title,
          description: form.description,
          type_id: form.type_id,
          signature_start_time: form.signature_start_time,
          signature_end_time: form.signature_end_time,
          signature_type: 'online',
          state: 'created'
        )

        return initiative unless initiative.valid?

        initiative.save
        initiative
      end
    end
  end
end
