# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe ManageableInitiatives do
        let!(:user) { create(:user, :confirmed, organization: organization) }
        let!(:admin) do
          create(:user, :confirmed, :admin, organization: organization)
        end
        let!(:organization) { create(:organization) }
        let!(:user_initiatives) do
          create_list(:initiative, 3, organization: organization, author: user)
        end
        let!(:admin_initiatives) do
          create_list(:initiative, 3, organization: organization, author: admin)
        end

        context 'Initiative authors' do
          subject { described_class.new(organization, user, nil, nil) }

          it 'includes only user initiatives' do
            expect(subject).not_to include(*admin_initiatives)
          end
        end

        context 'Initiative promoters' do
          let(:promoter) { create(:user, organization:  organization) }
          subject { described_class.new(organization, promoter, nil, nil) }

          before(:each) do
            @promoter_initiatives = create_list(:initiative, 3, organization: organization)
            @promoter_initiatives.each do |initiative|
              create(:initiatives_committee_member, initiative: initiative, user: promoter)
            end
          end

          it 'includes only promoter initiatives' do
            expect(subject).to include(*@promoter_initiatives)
            expect(subject).not_to include(*user_initiatives)
            expect(subject).not_to include(*admin_initiatives)
          end
        end

        context 'Administrator users' do
          subject { described_class.new(organization, admin, nil, nil) }

          it 'includes all initiatives' do
            expect(subject).to include(*user_initiatives)
            expect(subject).to include(*admin_initiatives)
          end
        end
      end
    end
  end
end
