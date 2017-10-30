# frozen_string_literal: true

module Decidim
  module Initiatives
    # A form object used to collect additional data for the
    # organization that creates an initiative.
    class OrganizationForm < Form
      mimic :organization_data

      attribute :name, String
      attribute :id_document, String
      attribute :address, String

      validates :name, :id_document, :address, presence: true
    end
  end
end
