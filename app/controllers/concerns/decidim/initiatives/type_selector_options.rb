# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Initiatives
    module TypeSelectorOptions
      extend ActiveSupport::Concern

      include Decidim::TranslationsHelper

      included do
        helper_method :initiative_types_for_select

        private

        def initiative_types_for_select
          types = [["all", I18n.t("initiatives.filters.all", scope: "decidim.initiatives")]]

          InitiativesType.where(organization: current_organization).all.each do |type|
            types << [type.id, Truncato.truncate(translated_attribute(type.title), max_length: 25)]
          end

          types
        end
      end
    end
  end
end
