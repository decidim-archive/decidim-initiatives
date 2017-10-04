# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # A command with all the business logic that updates an
      # existing initiative.
      class UpdateInitiative < Rectify::Command
        # Public: Initializes the command.
        #
        # initiative - Decidim::Initiative
        # form       - A form object with the params.
        def initialize(initiative, form)
          @form = form
          @initiative = initiative
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?
          initiative.update(attributes)

          if initiative.valid?
            broadcast(:ok, initiative)
          else
            broadcast(:invalid, initiative)
          end
        end

        private

        attr_reader :form, :initiative

        def attributes
          {
            title: form.title,
            description: form.description,
            type_id: form.type_id,
            decidim_scope_id: form.decidim_scope_id,
            signature_type: form.signature_type
          }
        end
      end
    end
  end
end
