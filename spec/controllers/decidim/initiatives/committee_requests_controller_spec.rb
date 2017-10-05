# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe CommitteeRequestsController, type: :controller do
      routes { Decidim::Initiatives::Engine.routes }

      let(:organization) { create(:organization) }
      let(:initiative) { create(:created_initiative, organization: organization) }

      before do
        @request.env['decidim.current_organization'] = organization
      end

      context 'GET new' do
        context 'Owner requests membership' do
          before do
            sign_in initiative.author
          end

          it 'Owner is not allowed to request membership' do
            get :new, params: { initiative_id: initiative.to_param }
            expect(flash[:alert]).not_to be_empty
            expect(response).to have_http_status(302)
          end

        end

        context 'Authorized user' do
          let(:user) { create(:user, :confirmed, organization: organization) }

          before do
            create(:authorization, user: user)
            sign_in user
          end

          it 'Authorized users are allowed to request membership' do
            get :new, params: { initiative_id: initiative.to_param }
            expect(flash[:alert]).to be_blank
            expect(response).to have_http_status(200)
          end
        end

        context 'Unauthorized users do' do
          let(:user) { create(:user, :confirmed, organization: organization) }

          before do
            sign_in user
          end

          it 'are not allowed to request membership' do
            get :new, params: { initiative_id: initiative.to_param }
            expect(flash[:alert]).not_to be_empty
            expect(response).to have_http_status(302)
          end
        end
      end

      context 'GET spawn' do
        let(:user) { create(:user, :confirmed, organization: organization) }

        before do
          create(:authorization, user: user)
          sign_in user
        end

        it 'Membership request is created' do
          expect do
            get :new, params: { initiative_id: initiative.to_param }
          end.to change { InitiativesCommitteeMember.count }
        end
      end
    end
  end
end
