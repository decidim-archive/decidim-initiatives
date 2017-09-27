# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper methods for the create initiative wizard.
    module CreateInitiativeHelper
      include InitiativeHelper


      def signature_type_options
        options = []
        Initiative.signature_types.keys.each do |type|
          options << [
            I18n.t(
              type,
              scope: %w[activemodel attributes initiative signature_type_values]
            ), type
          ]
        end

        options
      end
    end
  end
end
