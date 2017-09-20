# frozen_string_literal: true

module Decidim
  module Initiatives
    # Simple helpers to handle markup variations for initiative votes partials
    module InitiativeVotesHelper
      # Returns the css classes used for initiative votes count in both initiative list and show pages
      #
      # from_initiatives_list - A boolean to indicate if the template is rendered from the initiatives list page
      #
      # Returns a hash with the css classes for the count number and label
      def votes_count_classes(from_initiatives_list)
        return { number: "card__support__number", label: "" } if from_initiatives_list
        { number: "extra__suport-number", label: "extra__suport-text" }
      end

      # Returns the css classes used for initiative vote button in both initiatives list and show pages
      #
      # from_initiatives_list - A boolean to indicate if the template is rendered from the initiatives list page
      #
      # Returns a string with the value of the css classes.
      def vote_button_classes(from_initiatives_list)
        return "small" if from_initiatives_list
        "expanded button--sc"
      end
    end
  end
end
