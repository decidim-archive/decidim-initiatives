# frozen_string_literal: true

module Decidim
  # Data store the committee members for the initiative
  class InitiativesCommitteeMember < ApplicationRecord
    belongs_to :initiative,
               foreign_key: 'decidim_initiatives_id',
               class_name: 'Decidim::Initiative'

    belongs_to :user,
               foreign_key: 'decidim_users_id',
               class_name:  'Decidim::User'

    enum state: %i[requested rejected accepted]

    validates :state, presence: true
    validates :user, uniqueness: { scope: :initiative }
  end
end
