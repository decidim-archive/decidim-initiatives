module Decidim
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
      return '' if attribute.blank?

      value = attribute.try(:[], I18n.locale.to_s)
      return value unless value.blank?

      attribute.each do |_, value|
        return value unless value.blank?
      end

      ''
    end
  end
end
