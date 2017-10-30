# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper functions for initiatives views
    module InitiativesHelper
      def creation_enabled?
        return Decidim::Initiatives.creation_enabled unless current_user

        Decidim::Initiatives.creation_enabled &&
          (current_user.authorizations.any? || current_user.user_groups.verified.any?)
      end

      def initiatives_filter_form_for(filter)
        content_tag :div, class: 'filters' do
          form_for filter,
                   builder: Decidim::Initiatives::InitiativesFilterFormBuilder,
                   url: url_for,
                   as: :filter,
                   method: :get,
                   remote: true,
                   html: { id: nil } do |form|
            yield form
          end
        end
      end
    end
  end
end
