# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Initiatives
    # Common logic to votable resources
    module Votable
      extend ActiveSupport::Concern

      included do
        helper_method :already_voted?, :authorized_to_vote?

        private

        def already_voted?
          InitiativesVote.where(initiative: @initiative, author: current_user).any?
        end

        def authorized_to_vote?
          current_user&.authorizations&.any?
        end
      end
    end
  end
end
