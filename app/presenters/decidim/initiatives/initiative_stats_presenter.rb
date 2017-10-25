# frozen_string_literal: true

module Decidim
  module Initiatives
    # A presenter to render statistics in the homepage.
    class InitiativeStatsPresenter < Rectify::Presenter
      attribute :initiative, Decidim::Initiative

      def supports_count
        initiative.initiative_supports_count
      end

      def comments_count
        Rails.cache.fetch(
          "initiative/#{initiative.id}/comments_count",
          expires_in: Decidim::Initiatives.stats_cache_expiration_time) do
          Decidim::Comments::Comment.where(commentable: initiative).count
        end
      end

      def meetings_count
        Rails.cache.fetch(
          "initiative/#{initiative.id}/meetings_count",
          expires_in: Decidim::Initiatives.stats_cache_expiration_time) do
          Decidim::Meetings::Meeting.where(feature: meetings_feature).count
        end
      end

      def assistants_count
        Rails.cache.fetch(
          "initiative/#{initiative.id}/assistants_count",
          expires_in: Decidim::Initiatives.stats_cache_expiration_time) do
          result = 0
          Decidim::Meetings::Meeting.where(feature: meetings_feature).each do |meeting|
            result += meeting.attendees_count
          end

          result
        end
      end

      private

      def meetings_feature
        @meetings_feature ||= Decidim::Feature.find_by(participatory_space: initiative, manifest_name: 'meetings')
      end
    end
  end
end
