# frozen_string_literal: true

require 'active_support/concern'

module Decidim
  module Initiatives
    # This concern contains the logic related to scopes.
    module Scopeable
      extend ActiveSupport::Concern

      included do
        helper_method :scopes, :has_scopes?

        private

        # Get top scopes for the current organization.
        def scopes
          current_organization.top_scopes
        end

        # Whether the current organization has scopes or not.
        #
        # Returns a boolean.
        def has_scopes?
          scopes.any?
        end
      end
    end
  end
end
