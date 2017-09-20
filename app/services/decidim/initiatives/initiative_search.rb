# frozen_string_literal: true

module Decidim
  module Initiatives
    # Service that encapsulates all logic related to filtering initiatives.
    class InitiativeSearch < Searchlight::Search
      # Public: Initializes the service.
      # feature     - nil
      # page        - The page number to paginate the results.
      # per_page    - The number of proposals to return per page.
      def initialize(options = {})
        super(options)
      end

      def base_query
        Decidim::Initiative.published.where(organization: options[:organization])
      end

      # Handle the search_text filter
      def search_search_text
        query
          .where("title->>'#{current_locale}' ILIKE ?", "%#{search_text}%")
          .or(query.where("description->>'#{current_locale}' ILIKE ?", "%#{search_text}%"))
      end

      # Handle the state filter
      def search_state
        case state
        when "open"
          query.open
        when "closed"
          query.closed
        else # Assume 'all'
          query
        end
      end

      def search_type
        return query if type == "all"

        query.where(type_id: type)
      end

      private

      def current_locale
        I18n.locale.to_s
      end
    end
  end
end
