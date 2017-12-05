# frozen_string_literal: true

require 'spec_helper'
require 'cancan/matchers'

describe Decidim::Initiatives::Abilities::CurrentUserAbility do
  subject { described_class.new(user, {}) }

  let(:organization) { create(:organization)}
  let(:initiative) { create(:initiative, organization: organization) }

  context 'admin dashboard' do
    context 'Plain users' do
      let(:user) { create(:user, organization: organization) }

      it 'do not have access to the admin dashboard' do
        expect(subject).not_to be_able_to(:read, :admin_dashboard)
      end
    end

    context 'authors' do
      let(:user) { initiative.author }

      it 'have access to the dashboard' do
        expect(subject).to be_able_to(:read, :admin_dashboard)
      end
    end

    context 'Committee members' do
      let(:user) { initiative.committee_members.approved.first.user }

      it 'have access to the dashboard as well' do
        expect(subject).to be_able_to(:read, :admin_dashboard)
      end
    end
  end

  context 'initiative creation' do
    context 'Authorization required' do
      before(:each) do
        Decidim::Initiatives.do_not_require_authorization = false
      end

      context 'authorized users' do
        let(:user) { create(:authorization).user }

        it 'can create initiatives' do
          expect(subject).to be_able_to(:create, Decidim::Initiative)
        end
      end

      context 'non authorized users' do
        let(:user) { build(:user) }

        it 'can not create initiatives' do
          expect(subject).not_to be_able_to(:create, Decidim::Initiative)
        end
      end
    end

    context 'Authorization not required' do
      before(:each) do
        Decidim::Initiatives.do_not_require_authorization = true
      end

      context 'authorized users' do
        let(:user) { create(:authorization).user }

        it 'can create initiatives' do
          expect(subject).to be_able_to(:create, Decidim::Initiative)
        end
      end

      context 'non authorized users' do
        let(:user) { build(:user) }

        it 'can create initiatives' do
          expect(subject).to be_able_to(:create, Decidim::Initiative)
        end
      end
    end
  end

  context 'read initiative' do
    let(:initiative) { create(:initiative, :created, organization: organization) }
    let(:other_initiative) { create(:initiative, :created, organization: organization) }

    context 'admin users' do
      let(:user) { create(:user, :admin, organization: organization) }

      it 'can read non published initiatives' do
        expect(subject).to be_able_to(:read, initiative)
      end
    end

    context 'initiative author' do
      let(:user) { initiative.author }

      it 'can read his non published initiatives' do
        expect(subject).to be_able_to(:read, initiative)
      end

      it 'can not read others unpublished initiatives' do
        expect(subject).not_to be_able_to(:read, other_initiative)
      end
    end

    context 'committee group members' do
      let(:user) { initiative.committee_members.approved.first.user }

      it 'can read his non published initiatives' do
        expect(subject).to be_able_to(:read, initiative)
      end

      it 'can not read others unpublished initiatives' do
        expect(subject).not_to be_able_to(:read, other_initiative)
      end
    end
  end

  context 'request membership' do
    let(:initiative) { create(:initiative, :created, organization: organization) }
    let(:other_initiative) { create(:initiative, :created, organization: organization) }

    context 'Authorization required' do
      before(:each) do
        Decidim::Initiatives.do_not_require_authorization = false
      end

      context 'non authorized users' do
        let(:user) { create(:user, organization: organization) }

        it 'can not request membership' do
          expect(subject).not_to be_able_to(:request_membership, initiative)
        end
      end
    end

    context 'Authorization not required' do
      before(:each) do
        Decidim::Initiatives.do_not_require_authorization = true
      end

      context 'non authorized users' do
        let(:user) { create(:user, organization: organization) }

        it 'can request membership' do
          expect(subject).to be_able_to(:request_membership, initiative)
        end
      end
    end

    context 'authorized users' do
      let(:user) { create(:authorization).user }

      it 'can request membership' do
        expect(subject).to be_able_to(:request_membership, initiative)
      end
    end

    context 'initiative author' do
      let(:user) { initiative.author }

      it 'can not request membership' do
        expect(subject).not_to be_able_to(:request_membership, initiative)
      end
    end

    context 'committee group members' do
      let(:user) { initiative.committee_members.approved.first.user }

      it 'can not request membership' do
        expect(subject).not_to be_able_to(:request_membership, initiative)
      end
    end
  end
end
