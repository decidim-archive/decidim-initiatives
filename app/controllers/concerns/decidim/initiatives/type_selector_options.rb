# frozen_string_literal: true

require 'active_support/concern'

module Decidim
  module Initiatives
    module TypeSelectorOptions
      extend ActiveSupport::Concern

      include Decidim::TranslationsHelper

      included do
        helper_method :available_initiative_types, :initiative_types_for_select, :initiative_types_each

        private

        def available_initiative_types
          Decidim::Initiatives::InitiativeTypes.for(current_organization)
        end

        def initiative_types_for_select
          types = [['all', I18n.t('initiatives.filters.all', scope: 'decidim.initiatives')]]

          available_initiative_types.each do |type|
            types << [type.id, Truncato.truncate(translated_attribute(type.title), max_length: 25)]
          end

          types
        end

        def initiative_types_each
          available_initiative_types.each do |type|
            yield(type)
          end
        end
      end
    end
  end
end
