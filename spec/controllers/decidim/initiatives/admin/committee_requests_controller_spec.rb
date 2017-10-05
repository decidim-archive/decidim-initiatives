# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe CommitteeRequestsController, type: :controller do
        routes { Decidim::Initiatives::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let(:initiative) { create(:created_initiative, organization: organization) }

        before do
          @request.env['decidim.current_organization'] = organization
        end

        context 'GET approve' do
          let(:membership_request) { create(:initiatives_committee_member, initiative: initiative, state: 'requested')}

          context 'Owner' do
            before do
              sign_in initiative.author
            end

            it 'request gets approved' do
              get :approve, params: { initiative_id: membership_request.initiative.to_param, id: membership_request.to_param }
              membership_request.reload
              expect(membership_request).to be_accepted
            end
          end

          context 'Other users' do
            let(:user) { create(:user, :confirmed, organization: organization) }

            before do
              create(:authorization, user: user)
              sign_in user
            end

            it 'Action is denied' do
              get :approve, params: { initiative_id: membership_request.initiative.to_param, id: membership_request.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end
        end

        context 'DELETE revoke' do
          let(:membership_request) { create(:initiatives_committee_member, initiative: initiative, state: 'requested')}

          context 'Owner' do
            before do
              sign_in initiative.author
            end

            it 'request gets approved' do
              delete :revoke, params: { initiative_id: membership_request.initiative.to_param, id: membership_request.to_param }
              membership_request.reload
              expect(membership_request).to be_rejected
            end
          end

          context 'Other users' do
            let(:user) { create(:user, :confirmed, organization: organization) }

            before do
              create(:authorization, user: user)
              sign_in user
            end

            it 'Action is denied' do
              delete :revoke, params: { initiative_id: membership_request.initiative.to_param, id: membership_request.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end
        end
      end
    end
  end
end
