# frozen_string_literal: true

module Decidim
  # The data store for a Initiative in the Decidim::Initiatives component.
  class Initiative < ApplicationRecord
    include Decidim::Authorable
    include Decidim::Publicable
    include Decidim::Scopable
    include Decidim::Comments::Commentable
    include Decidim::Followable

    belongs_to :organization,
               foreign_key: 'decidim_organization_id',
               class_name: 'Decidim::Organization'

    belongs_to :type,
               foreign_key: 'type_id',
               class_name: 'Decidim::InitiativesType'

    belongs_to :scope,
               foreign_key: 'decidim_scope_id',
               class_name: 'Decidim::Scope',
               optional: true

    has_many :votes,
             foreign_key: 'decidim_initiative_id',
             class_name: 'Decidim::InitiativesVote'

    has_many :committee_members,
             foreign_key: 'decidim_initiatives_id',
             class_name: 'Decidim::InitiativesCommitteeMember'

    has_many :categories,
             foreign_key: 'decidim_participatory_space_id',
             foreign_type: 'decidim_participatory_space_type',
             dependent: :destroy,
             as: :participatory_space

    enum signature_type: %i[online offline any]
    enum state: %i[
      created validating validated discarded published rejected accepted
    ]

    validates :title, :description, :state, presence: true
    validates :signature_type, presence: true
    validates :signature_end_time, date: { after: :signature_start_time }, if: :has_signature_interval_defined?

    mount_uploader :banner_image, Decidim::BannerImageUploader

    scope :open, -> {
      published
        .where.not(state: %i[discarded rejected accepted])
        .where('signature_start_time <= ?', DateTime.now)
        .where('signature_end_time >= ?', DateTime.now)
    }
    scope :closed, -> {
      published
        .where(state: %i[discarded rejected accepted])
    }
    scope :published, -> { where.not(published_at: nil) }

    def self.order_randomly(seed)
      transaction do
        connection.execute("SELECT setseed(#{connection.quote(seed)})")
        order('RANDOM()').load
      end
    end

    def open?
      !closed?
    end

    def closed?
      discarded? || rejected? || accepted? || !votes_enabled?
    end

    def author_name
      user_group&.name || author.name
    end

    def author_avatar_url
      author.avatar&.url || ActionController::Base.helpers.asset_path('decidim/default-avatar.svg')
    end

    def votes_enabled?
      published? &&
        signature_start_time <= Date.today &&
        signature_end_time >= Date.today
    end

    # Public: Checks if the organization has given an answer for the initiative.
    #
    # Returns Boolean.
    def answered?
      answered_at.present?
    end

    #
    # Public: Publishes this feature
    #
    # Returns true if the record was properly saved, false otherwise.
    def publish!
      return false if published?
      update_attributes(
        published_at: Time.current,
        state: 'published',
        signature_start_time: DateTime.now,
        signature_end_time: DateTime.now + Decidim::Initiatives.default_signature_time_period_length
      )
    end

    #
    # Public: Unpublishes this feature
    #
    # Returns true if the record was properly saved, false otherwise.
    def unpublish!
      return false unless published?
      update_attributes(published_at: nil, state: 'validated')
    end

    def has_signature_interval_defined?
      signature_end_time.present? && signature_start_time.present?
    end
  end
end
