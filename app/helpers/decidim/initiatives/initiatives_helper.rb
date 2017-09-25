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
        Decidim::Initiatives.creation_enabled
      end
    end
  end
end
