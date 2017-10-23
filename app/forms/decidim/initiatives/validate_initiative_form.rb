# frozen_string_literal: true

module Decidim
  module Initiatives
    # A form object used to collect additional data from the initiative author
    class ValidateInitiativeForm < Form
      mimic :initiative_author

      attribute :name, String
      attribute :id_document, String
      attribute :address, String
      attribute :city, String
      attribute :province, String
      attribute :post_code, String
      attribute :phone_number, String

      validates :name, :id_document, :address, :city, :province, :post_code, presence: true
    end
  end
end
