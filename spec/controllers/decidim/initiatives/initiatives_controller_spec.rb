# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe InitiativesController, type: :controller do
      routes { Decidim::Initiatives::Engine.routes }

      let(:organization) { create(:organization) }
      let!(:initiative) { create(:initiative, organization: organization) }
      let!(:created_initiative) { create(:initiative, :created, organization: organization) }

      before do
        @request.env['decidim.current_organization'] = organization
      end

      describe 'GET index' do
        it 'Only returns published initiatives' do
          get :index
          expect(subject.helpers.initiatives).to include(initiative)
          expect(subject.helpers.initiatives).not_to include(created_initiative)
        end

        context 'order by most_voted' do
          let(:voted_initiative) { create(:initiative, organization: organization) }
          let!(:vote) { create(:initiative_user_vote, initiative: voted_initiative) }

          it 'most voted appears first' do
            get :index, params: { order: 'most_voted' }

            expect(subject.helpers.initiatives.first).to eq(voted_initiative)
          end
        end

        context 'order by most recent' do
          let!(:old_initiative) { create(:initiative, organization: organization, created_at: initiative.created_at - 12.months) }

          it 'most recent appears first' do
            get :index, params: { order: 'recent' }
            expect(subject.helpers.initiatives.first).to eq(initiative)
          end
        end

        context 'order by most commented' do
          let(:commented_initiative) { create(:initiative, organization: organization) }
          let!(:comment) { create(:comment, commentable: commented_initiative) }

          it 'most commented appears fisrt' do
            get :index, params: { order: 'most_commented' }
            expect(subject.helpers.initiatives.first).to eq(commented_initiative)
          end
        end
      end

      describe 'GET show' do
        context 'Any user' do
          it 'Shows published initiatives' do
            get :show, params: { slug: initiative.slug }
            expect(subject.helpers.current_initiative).to eq(initiative)
          end

          it 'Throws exception on non published initiatives' do
            get :show, params: { slug: created_initiative.slug }
            expect(flash[:alert]).not_to be_empty
            expect(response).to have_http_status(302)
          end
        end

        context 'Initiative Owner' do
          before do
            sign_in created_initiative.author
          end

          it 'Unpublished initiatives are shown too' do
            get :show, params: { slug: created_initiative.slug }
            expect(subject.helpers.current_initiative).to eq(created_initiative)
          end
        end
      end

      describe 'GET signature_identities' do
        let!(:group_vote) { create(:organization_user_vote, initiative: initiative) }

        before do
          group_vote.author.confirm
          sign_in group_vote.author
        end

        it 'voted_groups is a list of groups represented by the user that supported the initiative' do
          get :signature_identities, params: { slug: initiative.slug }

          expect(assigns[:voted_groups]).to include(group_vote.id)
        end
      end
    end
  end
end
