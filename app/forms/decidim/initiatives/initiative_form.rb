# frozen_string_literal: true

module Decidim
  module Initiatives
    # A form object used to collect the title and description for an initiative.
    class InitiativeForm < Form
      include TranslatableAttributes

      mimic :initiative

      attribute :title, String
      attribute :description, String
      attribute :type_id, Integer
      attribute :scope_id, Integer
      attribute :decidim_user_group_id, Integer
      attribute :signature_type, String

      validates :title, :description, presence: true, etiquette: true
      validates :title, length: { maximum: 150 }
      validates :signature_type, presence: true
      validates :type_id, presence: true
      validates :scope_id, presence: true, if: ->(form) { form.scope_id.present? }
    end
  end
end
