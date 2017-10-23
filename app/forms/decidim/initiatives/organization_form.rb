# frozen_string_literal: true

module Decidim
  module Initiatives
    # A form object used to collect additional data from the initiative author
    class OrganizationForm < Form
      mimic :organization_data

      attribute :name, String
      attribute :id_document, String
      attribute :address, String

      validates :name, :id_document, :address, presence: true
    end
  end
end
