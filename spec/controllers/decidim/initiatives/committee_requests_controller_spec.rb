# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Initiatives
    describe CommitteeRequestsController, type: :controller do
      routes { Decidim::Initiatives::Engine.routes }

      let(:organization) { create(:organization) }
      let!(:initiative) { create(:initiative, :created, organization: organization) }

      before do
        request.env["decidim.current_organization"] = organization
      end

      context "when GET new" do
        context "with owner requests membership" do
          before do
            sign_in initiative.author, scope: :user
          end

          it "Owner is not allowed to request membership" do
            get :new, params: { initiative_slug: initiative.slug }
            expect(flash[:alert]).not_to be_empty
            expect(response).to have_http_status(302)
          end
        end

        context "with authorized user" do
          let(:user) { create(:user, :confirmed, organization: organization) }

          before do
            create(:authorization, user: user)
            sign_in user, scope: :user
          end

          it "are allowed to request membership" do
            get :new, params: { initiative_slug: initiative.slug }
            expect(flash[:alert]).to be_blank
            expect(response).to have_http_status(200)
          end
        end

        context "with unauthorized users do" do
          let(:user) { create(:user, :confirmed, organization: organization) }

          before do
            sign_in user, scope: :user
          end

          it "are not allowed to request membership" do
            get :new, params: { initiative_slug: initiative.slug }
            expect(flash[:alert]).not_to be_empty
            expect(response).to have_http_status(302)
          end
        end
      end

      context "when GET spawn" do
        let(:user) { create(:user, :confirmed, organization: organization) }

        before do
          create(:authorization, user: user)
          sign_in user, scope: :user
        end

        context "and created initiative" do
          it "Membership request is created" do
            expect do
              get :spawn, params: { initiative_slug: initiative.slug }
            end.to change { InitiativesCommitteeMember.count }.by(1)
          end

          it "Duplicated requests finish with an error" do
            expect do
              get :spawn, params: { initiative_slug: initiative.slug }
            end.to change { InitiativesCommitteeMember.count }.by(1)

            expect do
              get :spawn, params: { initiative_slug: initiative.slug }
            end.to change { InitiativesCommitteeMember.count }.by(0)
          end
        end

        context "and published initiative" do
          let!(:published_initiative) { create(:initiative) }

          it "Membership request is not created" do
            expect do
              get :spawn, params: { initiative_slug: published_initiative.slug }
            end.to change { InitiativesCommitteeMember.count }.by(0)
          end
        end
      end
    end
  end
end
