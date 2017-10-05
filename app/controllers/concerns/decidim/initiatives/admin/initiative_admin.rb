# frozen_string_literal: true

require 'active_support/concern'

module Decidim
  module Initiatives
    module Admin
      # This concern is meant to be included in all controllers that are scoped
      # into an initiative's admin panel. It will override the layout so it shows
      # the sidebar, preload the assembly, etc.
      module InitiativeAdmin
        extend ActiveSupport::Concern

        included do
          include NeedsInitiative

          layout 'decidim/admin/initiative'
          helper Decidim::PartialTranslationsHelper

          alias_method :current_participatory_space, :current_initiative
        end
      end
    end
  end
end
