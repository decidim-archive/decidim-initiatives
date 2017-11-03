# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe SpawnCommitteeRequest do
      let(:initiative) { create(:initiative, :created) }
      let(:current_user) { create(:user, organization: initiative.organization) }
      let(:command) { described_class.new(initiative, current_user) }

      context 'Duplicated request' do
        let!(:committee_request) { create(:initiatives_committee_member, user: current_user, initiative: initiative) }

        it 'broadcasts invalid' do
          expect { command.call }.to broadcast :invalid
        end
      end

      context 'When everything is ok' do
        it 'broadcasts ok' do
          expect { command.call }.to broadcast :ok
        end

        it 'Creates a committee membership request' do
          expect do
            command.call
          end.to change { InitiativesCommitteeMember.count }
        end

        it 'Request state is requested' do
          command.call
          request = InitiativesCommitteeMember.last
          expect(request.requested?).to be_truthy
        end
      end
    end
  end
end
