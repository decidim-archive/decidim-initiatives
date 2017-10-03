# frozen_string_literal: true

require 'decidim/faker/localized'
require 'decidim/dev'

FactoryGirl.define do
  factory :initiatives_type, class: Decidim::InitiativesType do
    title { Decidim::Faker::Localized.sentence(3) }
    description { Decidim::Faker::Localized.wrapped('<p>', '</p>') { Decidim::Faker::Localized.sentence(4) } }
    supports_required 1000
    organization
  end

  factory :initiative, class: Decidim::Initiative do
    title { Decidim::Faker::Localized.sentence(3) }
    description { Decidim::Faker::Localized.wrapped('<p>', '</p>') { Decidim::Faker::Localized.sentence(4) } }
    organization
    author { create(:user, :confirmed, organization: organization) }
    published_at { Time.current }
    type { create(:initiatives_type, organization: organization) }
    state 'published'
    signature_type 'online'
    signature_start_time { Time.current }
    signature_end_time { Time.current + 120.days}

    after(:create) do |initiative|
      create(:authorization, user: initiative.author)

      3.times do
        create(:initiatives_committee_member, initiative: initiative)
      end
    end
  end

  factory :created_initiative, class: Decidim::Initiative do
    title { Decidim::Faker::Localized.sentence(3) }
    description { Decidim::Faker::Localized.wrapped('<p>', '</p>') { Decidim::Faker::Localized.sentence(4) } }
    organization
    author { create(:user, :confirmed, organization: organization) }
    published_at nil
    type { create(:initiatives_type, organization: organization) }
    state 'created'
    signature_type 'online'
    signature_start_time nil
    signature_end_time nil
    after(:create) do |initiative|
      create(:authorization, user: initiative.author)

      3.times do
        create(:initiatives_committee_member, initiative: initiative)
      end
    end
  end

  factory :initiative_user_vote, class: Decidim::InitiativesVote do
    initiative { create(:initiative) }
    author { create(:user, :confirmed, organization: initiative.organization) }
  end

  factory :organization_user_vote, class: Decidim::InitiativesVote do
    initiative { create(:initiative) }
    author { create(:user, organization: initiative.organization) }
    decidim_user_group_id { create(:user_group).id }
    after(:create) do |support|
      create(:user_group_membership, user: support.author, user_group: Decidim::UserGroup.find(support.decidim_user_group_id))
    end
  end

  factory :initiatives_committee_member, class: Decidim::InitiativesCommitteeMember do
    initiative { create(:initiative) }
    user { create(:user, organization: initiative.organization) }
    state 'accepted'
  end
end
