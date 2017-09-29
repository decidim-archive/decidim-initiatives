# frozen_string_literal: true

module Decidim
  # Initiatives can be voted by users and supported by organizations.
  class InitiativesVote < ApplicationRecord
    belongs_to :author, foreign_key: 'decidim_author_id', class_name: 'Decidim::User'
    belongs_to :user_group, foreign_key: 'decidim_user_group_id', class_name: 'Decidim::UserGroup', optional: true

    belongs_to :initiative, foreign_key: 'decidim_initiative_id', class_name: 'Decidim::Initiative'

    validates :initiative, uniqueness: { scope: %i[author user_group] }

    after_commit :update_counter_cache, on: %i[create destroy]

    scope :supports, -> { where.not(decidim_user_group_id: nil) }
    scope :votes, -> { where(decidim_user_group_id: nil) }

    private

    def update_counter_cache
      initiative.initiative_votes_count = Decidim::InitiativesVote
                                          .votes
                                          .where(decidim_initiative_id: initiative.id)
                                          .count

      initiative.save
    end
  end
end
