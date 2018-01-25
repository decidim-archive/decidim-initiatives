# frozen_string_literal: true

module Decidim
  module Initiatives
    # A command with all the business logic that creates a new initiative.
    class CreateInitiative < Rectify::Command
      include CurrentLocale

      # Public: Initializes the command.
      #
      # form - A form object with the params.
      # current_user - Current user.
      def initialize(form, current_user)
        @form = form
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?
        initiative = create_initiative

        if initiative.persisted?
          broadcast(:ok, initiative)
        else
          broadcast(:invalid, initiative)
        end
      end

      private

      attr_reader :form, :current_user

      # Creates the initiative and all default features
      def create_initiative
        initiative = build_initiative
        return initiative unless initiative.valid?

        initiative.transaction do
          initiative.save!
          create_features_for(initiative)
          send_notification(initiative)
        end

        initiative
      end

      def build_initiative
        Initiative.new(
          organization: form.current_organization,
          title: { current_locale => form.title },
          description: { current_locale => form.description },
          author: current_user,
          decidim_user_group_id: form.decidim_user_group_id,
          scoped_type: scoped_type,
          signature_type: form.signature_type,
          state: 'created'
        )
      end

      def scoped_type
        InitiativesTypeScope.find_by(
          decidim_initiatives_types_id: form.type_id,
          decidim_scopes_id: form.scope_id
        )
      end

      def create_features_for(initiative)
        Decidim::Initiatives.default_features.each do |feature_name|
          feature = Decidim::Feature.create!(
            name: Decidim::Features::Namer.new(
              initiative.organization.available_locales,
              feature_name).i18n_name,
            manifest_name: feature_name,
            published_at: Time.current,
            participatory_space: initiative
          )

          initialize_pages(feature) if feature_name == :pages
        end
      end

      def initialize_pages(feature)
        Decidim::Pages::CreatePage.call(feature) do
          on(:invalid) { raise "Can't create page" }
        end
      end

      def send_notification(initiative)
        Decidim::EventsManager.publish(
          event: "decidim.events.initiatives.initiative_created",
          event_class: Decidim::Initiatives::CreateInitiativeEvent,
          resource: initiative,
          recipient_ids: initiative.author.followers.pluck(:id)
        )
      end
    end
  end
end
