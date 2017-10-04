# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # A form object used to show the initative data for technical validation.
      class InitiativeForm < Form
        include TranslatableAttributes

        mimic :initiative

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :type_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :signature_type, String

        validates :title, :description, presence: true
        validates :signature_type, presence: true
        validates :type_id, presence: true
        validates :decidim_scope_id, presence: true, if: ->(form) { form.decidim_scope_id.present? }
      end
    end
  end
end
