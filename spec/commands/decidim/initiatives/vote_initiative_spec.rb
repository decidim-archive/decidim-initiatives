# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe VoteInitiative do
      let(:initiative) { create(:initiative) }
      let(:current_user) { create(:user, organization: initiative.organization) }

      describe 'User votes initiative' do
        let(:command) { described_class.new(initiative, current_user, nil) }

        it 'broadcasts ok' do
          expect { command.call }.to broadcast :ok
        end

        it 'Creates a vote' do
          expect do
            command.call
          end.to change { InitiativesVote.count }.by(1)
        end

        it 'Increases the vote counter by one' do
          expect do
            command.call
            initiative.reload
          end.to change { initiative.initiative_votes_count }.by(1)
        end
      end

      describe 'Organization supports initiative' do
        let(:user_group) { create(:user_group) }
        let(:user_group_membership) { create(:user_group_membership, user: current_user, user_group: user_group) }
        let(:command) { described_class.new(initiative, current_user, user_group.id) }

        it 'broadcasts ok' do
          expect { command.call }.to broadcast :ok
        end

        it 'Creates a vote' do
          expect do
            command.call
          end.to change { InitiativesVote.count }.by(1)
        end

        it 'Do not increases the vote counter by one' do
          command.call
          initiative.reload
          expect(initiative.initiative_votes_count).to be_zero
        end
      end
    end
  end
end