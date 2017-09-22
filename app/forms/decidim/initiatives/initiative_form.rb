# frozen_string_literal: true

module Decidim
  module Initiatives
    # A form object used to collect the title and description for an initiative.
    class InitiativeForm < Form
      include TranslatableAttributes

      mimic :initiative

      translatable_attribute :title, String
      translatable_attribute :description, String
      attribute :type_id, Integer
      attribute :signature_start_time, Date
      attribute :signature_end_time, Date

      validates :title, :description, translatable_presence: true
      validates :type_id,
                :signature_start_time,
                :signature_end_time,
                presence: true
    end
  end
end
