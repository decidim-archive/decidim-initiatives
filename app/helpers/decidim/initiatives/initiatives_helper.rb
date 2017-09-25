# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper functions for initiatives views
    module InitiativesHelper
      include PaginateHelper
      include InitiativeVotesHelper
      include InitiativeHelper
      include Decidim::Comments::CommentsHelper
      include Decidim::Admin::IconLinkHelper

      def creation_enabled?
        return Decidim::Initiatives.creation_enabled unless current_user 

        Decidim::Initiatives.creation_enabled && current_user.authorizations.any?
      end
    end
  end
end
