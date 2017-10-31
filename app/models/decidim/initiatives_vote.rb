# frozen_string_literal: true

require 'digest/sha1'

module Decidim
  # Initiatives can be voted by users and supported by organizations.
  class InitiativesVote < ApplicationRecord
    include Decidim::PartialTranslationsHelper

    belongs_to :author, foreign_key: 'decidim_author_id', class_name: 'Decidim::User'
    belongs_to :user_group, foreign_key: 'decidim_user_group_id', class_name: 'Decidim::UserGroup', optional: true

    belongs_to :initiative, foreign_key: 'decidim_initiative_id', class_name: 'Decidim::Initiative'

    validates :initiative, uniqueness: { scope: %i[author user_group] }

    after_commit :update_counter_cache, on: %i[create destroy]

    scope :supports, -> { where.not(decidim_user_group_id: nil) }
    scope :votes, -> { where(decidim_user_group_id: nil) }

    # PUBLIC
    #
    # Generates a hashed representation of the initiative support.
    def sha1
      return unless decidim_user_group_id.nil?

      unique_id = author.authorizations.first&.unique_id || author.email
      title = partially_translated_attribute(initiative.title)
      description = partially_translated_attribute(initiative.description)

      Digest::SHA1.hexdigest "#{unique_id}#{title}#{description}"
    end

    private

    def update_counter_cache
      initiative.initiative_votes_count = Decidim::InitiativesVote
                                          .votes
                                          .where(decidim_initiative_id: initiative.id)
                                          .count

      initiative.initiative_supports_count = Decidim::InitiativesVote
                                             .supports
                                             .where(decidim_initiative_id: initiative.id)
                                             .count

      initiative.save
    end
  end
end
