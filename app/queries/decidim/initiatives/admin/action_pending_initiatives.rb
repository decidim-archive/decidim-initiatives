# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # Class uses to initiatives waiting for administrator action
      class ActionPendingInitiatives < Rectify::Query
        # Syntactic sugar to initialize the class and return the queried objects
        #
        # organization - Decidim::Organization
        def self.for(organization)
          new(organization).query
        end

        # Initializes the class.
        #
        # organization - Decidim::Organization
        def initialize(organization)
          @organization = organization
        end

        # Retrieves similar initiatives
        def query
          Initiative
            .where(organization: @organization)
            .where(state: %i[validating accepted])
        end
      end
    end
  end
end
