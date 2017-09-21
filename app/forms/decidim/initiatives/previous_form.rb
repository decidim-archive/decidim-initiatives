# frozen_string_literal: true

module Decidim
  module Initiatives
    # A form object used to collect the title and description for an initiative.
    class PreviousForm < Form
      include TranslatableAttributes

      alias save valid?
      
      mimic :initiative

      translatable_attribute :title, String
      translatable_attribute :description, String
      attribute :type_id, Integer

      validates :title, :description, translatable_presence: true
      validates :type_id, presence: true
    end
  end
end
