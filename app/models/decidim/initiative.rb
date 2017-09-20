# frozen_string_literal: true

module Decidim
  # The data store for a Initiative in the Decidim::Initiatives component.
  class Initiative < ApplicationRecord
    include Decidim::Publicable
    include Decidim::Scopable
    include Decidim::Comments::Commentable

    belongs_to :organization,
               foreign_key: "decidim_organization_id",
               class_name: "Decidim::Organization"

    belongs_to :author, foreign_key: "decidim_author_id", class_name: "Decidim::User"
    belongs_to :type, foreign_key: "type_id", class_name: 'Decidim::InitiativesType'
    belongs_to :scope,
               foreign_key: "decidim_scope_id",
               class_name: "Decidim::Scope",
               optional: true

    has_many :votes, foreign_key: 'decidim_initiative_id', class_name: 'Decidim::InitiativesVote'
    has_many :categories,
             foreign_key: "decidim_participatory_space_id",
             foreign_type: "decidim_participatory_space_type",
             dependent: :destroy,
             as: :participatory_space

    enum signature_type: %i(online offline any)
    enum state: %i(created rejected accepted)

    validates :title, :description, :state, presence: true
    validates :signature_type, :signature_start_time, :signature_end_time, presence: true
    validates :signature_end_time, date: { after: :signature_start_time }

    mount_uploader :banner_image, Decidim::BannerImageUploader

    scope :published, ->{ where("published_at <= ?", DateTime.now) }
    scope :open, ->{ where("signature_end_time >= ?", DateTime.now) }
    scope :closed, -> { where("signature_end_time < ?", DateTime.now) }

    def self.order_randomly(seed)
      transaction do
        connection.execute("SELECT setseed(#{connection.quote(seed)})")
        order("RANDOM()").load
      end
    end

    def started?
      published? && signature_start_time <= Date.today
    end

    def votes_enabled?
      published? && signature_start_time <= Date.today && signature_end_time >= Date.today
    end

    def author_avatar_url
      author.avatar&.url || ActionController::Base.helpers.asset_path("decidim/default-avatar.svg")
    end

    def author_name
      author.name
    end

    # Public: Checks if the organization has given an answer for the initiative.
    #
    # Returns Boolean.
    def answered?
      answered_at.present?
    end
  end
end
