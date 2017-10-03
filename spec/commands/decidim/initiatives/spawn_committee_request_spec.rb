# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe SpawnCommitteeRequest do
      let(:initiative) { create(:created_initiative) }
      let(:current_user) { create(:user, organization: initiative.organization) }
      let(:command) { described_class.new(initiative, current_user) }

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
