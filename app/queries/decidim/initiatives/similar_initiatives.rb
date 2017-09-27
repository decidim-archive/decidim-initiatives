# frozen_string_literal: true

module Decidim
  module Initiatives
    # Class uses to retrieve similar initiatives types.
    class SimilarInitiatives < Rectify::Query
      include Decidim::TranslationsHelper

      # Syntactic sugar to initialize the class and return the queried objects.
      #
      # organization - Decidim::Organization
      # form - Decidim::Initiatives::PreviousForm
      def self.for(organization, form)
        new(organization, form).query
      end

      # Initializes the class.
      #
      # organization - Decidim::Organization
      # form - Decidim::Initiatives::PreviousForm
      def initialize(organization, form)
        @organization = organization
        @form = form
      end

      # Retrieves similar initiatives
      def query
        Initiative
          .published
          .where(organization: @organization)
          .where(
            "GREATEST(#{title_similarity}, #{description_similarity}) >= ?",
            Decidim::Initiatives.similarity_threshold
          )
          .limit(Decidim::Initiatives.similarity_limit)
      end

      private

      attr_reader :form

      def title_similarity
        title = Initiative.connection.quote(form.title)
        "similarity(title->>'#{current_locale}',#{title})"
      end

      def description_similarity
        description = Initiative.connection.quote(form.description)
        "similarity(description->>'#{current_locale}',#{description})"
      end

      def current_locale
        I18n.locale.to_s
      end
    end
  end
end
