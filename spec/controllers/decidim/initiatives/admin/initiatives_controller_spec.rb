# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    module Admin
      describe InitiativesController, type: :controller do
        routes { Decidim::Initiatives::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let!(:initiative) { create(:initiative, organization: organization) }
        let!(:created_initiative) { create(:created_initiative, organization: organization) }

        before do
          @request.env['decidim.current_organization'] = organization
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
      end
    end
  end
end



