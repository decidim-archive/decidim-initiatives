# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # A form object used to manage de initiative data from an administration
      # perspective
      class AcceptedInitiativeForm < Form
        include TranslatableAttributes

        mimic :initiative

        translatable_attribute :answer, String
        attribute :answer_url, String

        validates :answer, translatable_presence: true
        validates :answer_url, presence: true
      end
    end
  end
end
