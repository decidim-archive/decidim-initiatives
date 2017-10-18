# frozen_string_literal: true

module Decidim
  module Initiatives
    # Class uses to retrieve initiatives that have been a long time in validating state
    class OutdatedValidatingInitiatives < Rectify::Query
      # Syntactic sugar to initialize the class and return the queried objects.
      #
      # validating_period_length - Maximum time in validating state
      def self.for(validating_period_length)
        new(validating_period_length).query
      end

      # Initializes the class.
      #
      # validating_period_length - Maximum time in validating state
      def initialize(validating_period_length)
        @validating_period_length = DateTime.now - validating_period_length
      end

      # Retrieves the available initiative types for the given organization.
      def query
        Decidim::Initiative
          .where(state: 'validating')
          .where('updated_at < ?', @validating_period_length)
      end
    end
  end
end
