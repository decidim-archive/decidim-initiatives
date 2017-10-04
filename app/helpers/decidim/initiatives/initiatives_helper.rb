# frozen_string_literal: true

module Decidim
  module Initiatives
    # Helper functions for initiatives views
    module InitiativesHelper
      include PaginateHelper
      include InitiativeHelper
      include Decidim::Comments::CommentsHelper
      include Decidim::Admin::IconLinkHelper

      # This custom Form builder add the fields needed to deal with
      # Initiative types.
      class InitiativesFilterFormBuilder < Decidim::FilterFormBuilder
        # Public: Generates a select field with the initiative types.
        #
        # name       - The name of the field (usually type_id)
        # collection - A collection of initiative types.
        # options    - An optional Hash with options:
        # - prompt   - An optional String with the text to display as prompt.
        #
        # Returns a String.
        def initiative_types_select(name, options = {})
          selected = object.send(name)
          if selected.present?
            selected = selected.values if selected.is_a?(Hash)
            selected = [selected] unless selected.is_a?(Array)
            types = Decidim::InitiativesType.where(id: selected.map(&:to_i)).map do |type|
              [type.title[I18n.locale.to_s], type.id]
            end
          else
            types = []
          end

          prompt = options.delete(:prompt)
          remote_path = options.delete(:remote_path) || false
          multiple = options.delete(:multiple) || false
          html_options = {
            multiple: multiple,
            class: 'select2',
            'data-remote-path' => remote_path,
            'data-placeholder' => prompt
          }

          select(name, @template.options_for_select(types, selected: selected), options, html_options)
        end
      end

      def creation_enabled?
        return Decidim::Initiatives.creation_enabled unless current_user

        Decidim::Initiatives.creation_enabled &&
          (current_user.authorizations.any? || current_user.user_groups.verified.any?)
      end

      def initiatives_filter_form_for(filter)
        content_tag :div, class: 'filters' do
          form_for filter, builder: InitiativesFilterFormBuilder, url: url_for, as: :filter, method: :get, remote: true, html: { id: nil } do |form|
            yield form
          end
        end
      end
    end
  end
end
