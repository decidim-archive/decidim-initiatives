# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # Class that retrieves manageable initiatives for the given user.
      # Regular users will get only their initiatives. Administrators will
      # retrieve all initiatives.
      class ManageableInitiatives < Rectify::Query
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
