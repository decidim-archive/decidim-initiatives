# frozen_string_literal: true

module Decidim
  # Initiative type.
  class InitiativesType < ApplicationRecord
    validates :title, :description, :supports_required, presence: true
    validates :supports_required, numericality: {
      only_integer: true,
      greater_than: 0
    }

    belongs_to :organization,
               foreign_key: 'decidim_organization_id',
               class_name: 'Decidim::Organization'

    has_many :initiatives,
             foreign_key: 'type_id',
             class_name: 'Decidim::Initiative',
             dependent: :restrict_with_error
  end
end
