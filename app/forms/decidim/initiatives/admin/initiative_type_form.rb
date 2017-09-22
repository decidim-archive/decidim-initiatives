# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # A form object used to collect the all the initiative type attributes.
      class InitiativeTypeForm < Form
        include TranslatableAttributes

        mimic :initiatives_type

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :supports_required, Integer

        validates :title, :description, translatable_presence: true
        validates :supports_required, presence: true,
                                      numericality: {
                                        only_integer: true,
                                        greater_than: 0
                                      }
      end
    end
  end
end
