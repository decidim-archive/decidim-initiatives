# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe InitiativesController, type: :controller do
        routes { Decidim::Initiatives::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let!(:initiative) { create(:initiative, organization: organization) }
        let!(:created_initiative) { create(:initiative, :created, organization: organization) }

        before do
          @request.env['decidim.current_organization'] = organization
        end

        describe 'Users without initiatives' do
          let!(:user) { create(:user, organization: organization) }

          before do
            sign_in user
          end

          it 'initiative list is not allowed' do
            get :index
            expect(flash[:alert]).not_to be_empty
            expect(response).to have_http_status(302)
          end
        end

        describe 'GET send_to_technical_validation' do
          context 'Initiative not in created state' do
            before do
              sign_in initiative.author
            end

            it 'Raises an error' do
              get :send_to_technical_validation, params: { id: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'User is not the owner of the initiative' do
            let(:other_user) { create(:user, organization: organization ) }

            before do
              sign_in other_user
            end

            it 'Raises an error' do
              get :send_to_technical_validation, params: { id: created_initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'User is the owner of the initiative. It is in created state' do
            before do
              created_initiative.author.confirm
              sign_in created_initiative.author
            end

            it 'Passes to technical validation phase' do
              get :send_to_technical_validation, params: { id: created_initiative.to_param }

              created_initiative.reload
              expect(created_initiative).to be_validating
            end
          end
        end

        context 'POST publish' do
          let!(:initiative) { create(:initiative, :validating, organization: organization) }

          context 'Initiative owner' do
            before do
              sign_in initiative.author
            end

            it 'Raises an error' do
              post :publish, params: { id: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'Administrator' do
            let!(:admin) { create(:user, :confirmed, :admin) }

            before do
              sign_in admin
            end

            it 'initiative gets published' do
              post :publish, params: { id: initiative.to_param }
              expect(response).to have_http_status(302)

              initiative.reload
              expect(initiative.published?).to be_truthy
              expect(initiative.published_at).not_to be_nil
              expect(initiative.signature_start_time).not_to be_nil
              expect(initiative.signature_end_time).not_to be_nil
            end
          end
        end

        context 'DELETE unpublish' do
          context 'Initiative owner' do
            before do
              sign_in initiative.author
            end

            it 'Raises an error' do
              post :publish, params: { id: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'Administrator' do
            let!(:admin) { create(:user, :confirmed, :admin) }

            before do
              sign_in admin
            end

            it 'initiative gets unpublished' do
              delete :unpublish, params: { id: initiative.to_param }
              expect(response).to have_http_status(302)

              initiative.reload
              expect(initiative.published?).to be_falsey
              expect(initiative.discarded?).to be_truthy
              expect(initiative.published_at).to be_nil
            end
          end
        end

        context 'DELETE discard' do
          let!(:initiative) { create(:initiative, :validating, organization: organization) }

          context 'Initiative owner' do
            before do
              sign_in initiative.author
            end

            it 'Raises an error' do
              post :publish, params: { id: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'Administrator' do
            let!(:admin) { create(:user, :confirmed, :admin) }

            before do
              sign_in admin
            end

            it 'initiative gets discarded' do
              delete :discard, params: { id: initiative.to_param }
              expect(response).to have_http_status(302)

              initiative.reload
              expect(initiative.discarded?).to be_truthy
              expect(initiative.published_at).to be_nil
            end
          end
        end
      end
    end
  end
end



