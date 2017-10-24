# frozen_string_literal: true

module Decidim
  # The data store for initiative extra data in the Decidim::InitiativesExtraData component.
  class InitiativesExtraData < ApplicationRecord
    enum data_type: %i[author organization]

    belongs_to :initiative, foreign_key: 'decidim_initiative_id', class_name: 'Decidim::Initiative'

    validates :data_type, presence: true
    validates :data, presence: true
    validates :data_type, uniqueness: { scope: :decidim_initiative_id }

    scope :author, ->() { where(data_type: 'author') }
    scope :organization, ->() { where(data_type: 'organization') }
  end
end