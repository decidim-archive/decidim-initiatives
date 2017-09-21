# frozen_string_literal: true

module Decidim
  module Initiatives
    module InitiativesHelper
      include PaginateHelper
      include InitiativeVotesHelper
      include InitiativeHelper
      include Decidim::Comments::CommentsHelper
      
      def creation_enabled?
        Decidim::Initiatives.creation_enabled
      end
    end
  end
end
