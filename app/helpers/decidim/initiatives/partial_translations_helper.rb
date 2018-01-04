# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper that provides convenient methods to deal with translated attributes.
    module PartialTranslationsHelper
      # Public: Returns the translation of an attribute using the current locale,
      # if available, otherwise fallback to the first available translation.
      #
      # attribute - A Hash where keys (strings) are locales, and their values are
      #             the translation for each locale.
      #
      # Returns a String with the translation.
      def partially_translated_attribute(attribute)
        return "" if attribute.blank?

        value = attribute.try(:[], I18n.locale.to_s)
        return value if value.present?

        attribute.each do |_, attr_value|
          return attr_value if attr_value.present?
        end

        ""
      end
      module_function :partially_translated_attribute
    end
  end
end
