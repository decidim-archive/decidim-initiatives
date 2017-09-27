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

        validates :title, :description, translatable_presence: true
      end
    end
  end
end
