# frozen_string_literal: true

module Decidim
  module Initiatives
    # A command with all the business logic that creates a new initiative.
    class CreateInitiativeExtraData < Rectify::Command
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
        record = create_initiative_data

        if record.persisted?
          broadcast(:ok, record)
        else
          broadcast(:invalid, record)
        end
      end

      private

      attr_reader :form

      def create_initiative_data
        record = find_or_create_record

        record.data = author_data if record.author?
        record.data = organization_data if record.organization?
        record.save
        record
      end

      def find_or_create_record
        record = InitiativesExtraData.find_by(
          initiative: form.context.initiative,
          data_type: form.context.data_type
        )
        return record unless record.nil?

        InitiativesExtraData.new(
          initiative: form.context.initiative,
          data_type: form.context.data_type
        )
      end

      def author_data
        {
          name: form.name,
          id_document: form.id_document,
          address: form.address,
          city: form.city,
          province: form.province,
          post_code: form.post_code,
          phone_number: form.phone_number
        }
      end

      def organization_data
        {
          name: form.name,
          id_document: form.id_document,
          address: form.address
        }
      end
    end
  end
end
