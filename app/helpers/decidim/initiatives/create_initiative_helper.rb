# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper methods for the create initiative wizard.
    module CreateInitiativeHelper
      def signature_type_options
        return online_signature_type_options unless Decidim::Initiatives.face_to_face_voting_allowed

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

      def online_signature_type_options
        [
          [
            I18n.t(
              'online',
              scope: %w[activemodel attributes initiative signature_type_values]
            ), 'online'
          ]
        ]
      end
    end
  end
end
