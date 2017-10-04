# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # Class uses to initiatives waiting for administrator action
      class ActionPendingInitiatives < Rectify::Query
        attr_reader :organization, :user

        # Syntactic sugar to initialize the class and return the queried objects
        #
        # organization - Decidim::Organization
        # user         - Decidim::User
        def self.for(organization, user)
          new(organization, user).query
        end

        # Initializes the class.
        #
        # organization - Decidim::Organization
        def initialize(organization, user)
          @organization = organization
          @user = user
        end

        # Retrieves all initiatives / Initiatives created by the user.
        def query
          if user.admin?
            Initiative.where(organization: organization)
          else
            Initiative.where(author: user)
          end
        end
      end
    end
  end
end
