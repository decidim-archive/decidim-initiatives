# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # A command with all the business logic that updates an
      # existing initiative type scope.
      class UpdateInitiativeTypeScope < Rectify::Command
        # Public: Initializes the command.
        #
        # initiative_type: Decidim::InitiativesTypeScope
        # form - A form object with the params.
        def initialize(initiative_type_scope, form)
          @form = form
          @initiative_type_scope = initiative_type_scope
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?
          initiative_type_scope.update(attributes)

          if initiative_type_scope.valid?
            broadcast(:ok, initiative_type_scope)
          else
            initiative_type_scope.errors.each do |attribute, error|
              form.errors.add(attribute, error)
            end

            broadcast(:invalid, initiative_type_scope)
          end
        end

        private

        attr_reader :form, :initiative_type_scope

        def attributes
          {
            supports_required: form.supports_required,
            decidim_scopes_id: form.decidim_scopes_id
          }
        end
      end
    end
  end
end
