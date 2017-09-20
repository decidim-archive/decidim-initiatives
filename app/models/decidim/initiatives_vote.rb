# frozen_string_literal: true

module Decidim
  # Initiatives can be voted by users and supported by organizations.
  class InitiativesVote < ApplicationRecord
    belongs_to :initiative, foreign_key: "decidim_initiative_id", class_name: "Decidim::Initiative"
    belongs_to :author, foreign_key: "decidim_author_id", class_name: "Decidim::User"

    validates :initiative, uniqueness: { scope: :author }
    validate :author_and_initiative_same_organization

    enum scope: %i(votes supports)

    after_commit :update_counter_cache, on: [:create, :destroy]

    private

    # Private: check if the initiative and the author have the same organization
    def author_and_initiative_same_organization
      return if !initiative || !author
      errors.add(:initiative, :invalid) unless author.organization == initiative.organization
    end

    def update_counter_cache
      initiative.initiative_votes_count = Decidim::InitiativesVote
                                          .where(decidim_initiative_id: initiative.id, scope: 0)
                                          .count

      initiative.save
    end
  end
end
