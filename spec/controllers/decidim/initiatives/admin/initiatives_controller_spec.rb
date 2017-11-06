# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe InitiativesController, type: :controller do
        routes { Decidim::Initiatives::AdminEngine.routes }

        let(:user) { create(:user, :confirmed, organization: organization) }
        let(:admin_user) { create(:user, :admin, :confirmed, organization: organization) }
        let(:organization) { create(:organization) }
        let!(:initiative) { create(:initiative, organization: organization) }
        let!(:created_initiative) { create(:initiative, :created, organization: organization) }

        before do
          @request.env['decidim.current_organization'] = organization
        end

        context 'index' do
          describe 'Users without initiatives' do
            before do
              sign_in user
            end

            it 'initiative list is not allowed' do
              get :index
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'anonymous users do' do
            it 'initiative list is not allowed' do
              get :index
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'admin users' do
            before do
              sign_in admin_user
            end

            it 'initiative list is allowed' do
              get :index
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end

          describe 'initiative author' do
            before do
              sign_in initiative.author
            end

            it 'initiative list is allowed' do
              get :index
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end

          describe 'promotal committee members' do
            before do
              sign_in initiative.committee_members.approved.first.user
            end

            it 'initiative list is allowed' do
              get :index
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end
        end

        context 'show' do
          describe 'Users without initiatives' do
            before do
              sign_in user
            end

            it 'are not not allowed' do
              get :show, params: { slug: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'anonymous users do' do
            it 'are not allowed' do
              get :show, params: { slug: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'admin users' do
            before do
              sign_in admin_user
            end

            it 'are allowed' do
              get :show, params: { slug: initiative.to_param }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end

          describe 'initiative author' do
            before do
              sign_in initiative.author
            end

            it 'are allowed' do
              get :show, params: { slug: initiative.to_param }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end

          describe 'promotal committee members' do
            before do
              sign_in initiative.committee_members.approved.first.user
            end

            it 'initiative list is allowed' do
              get :show, params: { slug: initiative.to_param }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end
        end

        context 'edit' do
          describe 'Users without initiatives' do
            before do
              sign_in user
            end

            it 'are not allowed' do
              get :edit, params: { slug: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'anonymous users do' do
            it 'are not allowed' do
              get :edit, params: { slug: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'admin users' do
            before do
              sign_in admin_user
            end

            it 'are allowed' do
              get :edit, params: { slug: initiative.to_param }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end

          describe 'initiative author' do
            before do
              sign_in initiative.author
            end

            it 'are allowed' do
              get :edit, params: { slug: initiative.to_param }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end

          describe 'promotal committee members' do
            before do
              sign_in initiative.committee_members.approved.first.user
            end

            it 'are allowed' do
              get :edit, params: { slug: initiative.to_param }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end
        end

        context 'update' do
          let(:valid_attributes) { attributes_for(:initiative, organization: organization) }

          describe 'Users without initiatives' do
            before do
              sign_in user
            end

            it 'are not allowed' do
              put :update,
                  params: {
                    slug: initiative.to_param,
                    initiative: valid_attributes
                  }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'anonymous users do' do
            it 'are not allowed' do
              put :update,
                  params: {
                    slug: initiative.to_param,
                    initiative: valid_attributes
                  }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          describe 'admin users' do
            before do
              sign_in admin_user
            end

            it 'are allowed' do
              put :update,
                  params: {
                    slug: initiative.to_param,
                    initiative: valid_attributes
                  }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(302)
            end
          end

          context 'initiative author' do
            context 'initiative published' do
              before do
                sign_in initiative.author
              end

              it 'are not allowed' do
                put :update,
                    params: {
                      slug: initiative.to_param,
                      initiative: valid_attributes
                    }
                expect(flash[:alert]).not_to be_nil
                expect(response).to have_http_status(302)
              end
            end

            context 'initiative created' do
              let(:initiative) { create(:initiative, :created) }

              before do
                sign_in initiative.author
              end

              it 'are allowed' do
                put :update,
                    params: {
                      slug: initiative.to_param,
                      initiative: valid_attributes
                    }
                expect(flash[:alert]).to be_nil
                expect(response).to have_http_status(302)
              end
            end
          end

          context 'promotal committee members' do
            context 'initiative published' do
              before do
                sign_in initiative.committee_members.approved.first.user
              end

              it 'are not allowed' do
                put :update,
                    params: {
                      slug: initiative.to_param,
                      initiative: valid_attributes
                    }
                expect(flash[:alert]).not_to be_nil
                expect(response).to have_http_status(302)
              end
            end

            context 'initiative created' do
              let(:initiative) { create(:initiative, :created) }

              before do
                sign_in initiative.committee_members.approved.first.user
              end

              it 'are allowed' do
                put :update,
                    params: {
                      slug: initiative.to_param,
                      initiative: valid_attributes
                    }
                expect(flash[:alert]).to be_nil
                expect(response).to have_http_status(302)
              end
            end
          end
        end

        context 'GET send_to_technical_validation' do
          context 'Initiative not in created state' do
            before do
              sign_in initiative.author
            end

            it 'Raises an error' do
              get :send_to_technical_validation, params: { slug: initiative.to_param }
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
              get :send_to_technical_validation, params: { slug: created_initiative.to_param }
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
              get :send_to_technical_validation, params: { slug: created_initiative.to_param }

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
              post :publish, params: { slug: initiative.to_param }
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
              post :publish, params: { slug: initiative.to_param }
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
              delete :unpublish, params: { slug: initiative.to_param }
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
              delete :unpublish, params: { slug: initiative.to_param }
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
              delete :discard, params: { slug: initiative.to_param }
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
              delete :discard, params: { slug: initiative.to_param }
              expect(response).to have_http_status(302)

              initiative.reload
              expect(initiative.discarded?).to be_truthy
              expect(initiative.published_at).to be_nil
            end
          end
        end

        context 'POST accept' do
          let!(:initiative) { create(:initiative, :acceptable, signature_type: 'any', organization: organization) }

          context 'Initiative owner' do
            before do
              sign_in initiative.author
            end

            it 'Raises an error' do
              post :accept, params: { slug: initiative.to_param }
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
              post :accept, params: { slug: initiative.to_param }
              expect(response).to have_http_status(302)

              initiative.reload
              expect(initiative.accepted?).to be_truthy
            end
          end
        end

        context 'DELETE reject' do
          let!(:initiative) { create(:initiative, :rejectable, signature_type: 'any', organization: organization) }

          context 'Initiative owner' do
            before do
              sign_in initiative.author
            end

            it 'Raises an error' do
              delete :reject, params: { slug: initiative.to_param }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'Administrator' do
            let!(:admin) { create(:user, :confirmed, :admin) }

            before do
              sign_in admin
            end

            it 'initiative gets rejected' do
              delete :reject, params: { slug: initiative.to_param }
              expect(response).to have_http_status(302)
              expect(flash[:alert]).to be_nil

              initiative.reload
              expect(initiative.rejected?).to be_truthy
            end
          end
        end

        context 'GET export_votes' do
          let(:initiative) { create(:initiative, organization: organization, signature_type: 'any') }

          context 'author' do
            before do
              sign_in initiative.author
            end

            it 'is not allowed' do
              get :export_votes, params: { slug: initiative.to_param, format: :csv }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'promotal committee' do
            before do
              sign_in initiative.committee_members.approved.first.user
            end

            it 'is not allowed' do
              get :export_votes, params: { slug: initiative.to_param, format: :csv }
              expect(flash[:alert]).not_to be_empty
              expect(response).to have_http_status(302)
            end
          end

          context 'admin user' do
            let!(:vote) { create(:initiative_user_vote, initiative: initiative) }

            before do
              sign_in admin_user
            end

            it 'is allowed' do
              get :export_votes, params: { slug: initiative.to_param, format: :csv }
              expect(flash[:alert]).to be_nil
              expect(response).to have_http_status(200)
            end
          end
        end
      end
    end
  end
end



