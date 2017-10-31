# frozen_string_literal: true

Decidim.register_participatory_space(:initiatives) do |participatory_space|
  participatory_space.engine = Decidim::Initiatives::Engine
  participatory_space.admin_engine = Decidim::Initiatives::AdminEngine
  participatory_space.model_class_name = 'Decidim::Initiative'

  participatory_space.seeds do
    seeds_root = File.join(__dir__, '..', '..', '..', 'db', 'seeds')
    organization = Decidim::Organization.first

    3.times do |n|
      type = Decidim::InitiativesType.create!(
        title: Decidim::Faker::Localized.sentence(5),
        description: Decidim::Faker::Localized.sentence(25),
        organization: organization,
        banner_image: File.new(File.join(seeds_root, 'city2.jpeg')),
        requires_validation: true
      )

      organization.top_scopes.each do |scope|
        Decidim::InitiativesTypeScope.create(
          type: type,
          scope: scope,
          supports_required: (n + 1) * 1000
        )
      end
    end

    7.times do
      initiative = Decidim::Initiative.create!(
        title: Decidim::Faker::Localized.sentence(3),
        description: Decidim::Faker::Localized.sentence(25),
        scoped_type: Decidim::InitiativesTypeScope.reorder('RANDOM()').first,
        state: 'published',
        signature_type: 'online',
        signature_start_time: DateTime.now - 7.days,
        signature_end_time:  DateTime.now + 7.days,
        published_at: DateTime.now - 7.days,
        author: Decidim::User.reorder('RANDOM()').first,
        organization: organization
      )

      Decidim::Comments::Seed.comments_for(initiative)

      Decidim::Initiatives.default_features.each do |feature_name|
        feature = Decidim::Feature.create!(
          name: Decidim::Features::Namer.new(initiative.organization.available_locales, feature_name).i18n_name,
          manifest_name: feature_name,
          published_at: Time.current,
          participatory_space: initiative
        )

        next unless feature_name == :pages

        Decidim::Pages::CreatePage.call(feature) do
          on(:invalid) { raise "Can't create page" }
        end
      end
    end
  end
end
