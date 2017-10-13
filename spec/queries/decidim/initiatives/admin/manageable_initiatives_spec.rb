# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe ManageableInitiatives do
        let!(:user) { create(:user, :confirmed, organization: organization) }
        let!(:admin) { create(:user, :confirmed, :admin, organization: organization) }
        let!(:organization) { create(:organization) }
        let!(:user_initiatives) { create_list(:initiative, 3, organization: organization, author: user) }
        let!(:admin_initiatives) { create_list(:initiative, 3, organization: organization, author: admin) }

        context 'Regular users' do
          subject { described_class.new(organization, user) }

          it 'includes only user initiatives' do
            expect(subject).not_to include(*admin_initiatives)
          end
        end

        context 'Administrator users' do
          subject { described_class.new(organization, admin) }

          it 'includes all initiatives' do
            expect(subject).to include(*user_initiatives)
            expect(subject).to include(*admin_initiatives)
          end
        end
      end
    end
  end
end