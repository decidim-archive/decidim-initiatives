# frozen_string_literal: true

Decidim.register_participatory_space(:initiatives) do |participatory_space|
  participatory_space.engine = Decidim::Initiatives::Engine
  participatory_space.admin_engine = Decidim::Initiatives::AdminEngine

  participatory_space.seeds do
    organization = Decidim::Organization.first

    7.times do |n|
      type = Decidim::InitiativesType.create!(
        title: Decidim::Faker::Localized.sentence(5),
        description: Decidim::Faker::Localized.sentence(25),
        supports_required: (n+1)*1000,
        organization: organization
      )

      initiative = Decidim::Initiative.create!(
        title: Decidim::Faker::Localized.sentence(5),
        description: Decidim::Faker::Localized.sentence(25),
        type: type,
        state: "created",
        signature_type: "online",
        signature_start_time: DateTime.now - 7.days,
        signature_end_time:  DateTime.now + 7.days,
        published_at: DateTime.now - 7.days,
        scope: Faker::Boolean.boolean(0.5) ? nil : Decidim::Scope.reorder("RANDOM()").first,
        author: Decidim::User.reorder("RANDOM()").first,
        organization: organization
      )

      Decidim::Comments::Seed.comments_for(initiative)
    end
  end
end
