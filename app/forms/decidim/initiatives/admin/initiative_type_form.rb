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
        attribute :banner_image, String

        validates :title, :description, translatable_presence: true
        validates :banner_image, presence: true, if: ->(form) { form.context.initiative_type.nil? }

        def available_locales
          Decidim.available_locales
        end
      end
    end
  end
end
