# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe Initiative do
      context 'created initiative' do
        let(:initiative) { create(:initiative, :created) }
        let(:administrator) { create(:user, :admin, organization: initiative.organization) }

        before(:each) do
          @message_delivery = instance_double(ActionMailer::MessageDelivery)
          allow(@message_delivery).to receive(:deliver_later)
        end

        it 'technical revission request is notified by email' do
          expect(administrator).not_to be_nil
          expect(InitiativesMailer).to receive(:notify_validating_request)
                                         .at_least(:once)
                                         .and_return(@message_delivery)
          initiative.validating!
        end
      end

      context 'published initiative' do
        let(:published_initiative) { build :initiative }

        it 'is valid' do
          expect(published_initiative).to be_valid
        end

        it 'unpublish!' do
          published_initiative.unpublish!

          expect(published_initiative).to be_discarded
          expect(published_initiative.published_at).to be_nil
        end

        it 'signature_interval_defined?' do
          expect(published_initiative).to have_signature_interval_defined
        end

        context 'mailing' do
          before(:each) do
            @message_delivery = instance_double(ActionMailer::MessageDelivery)
            allow(@message_delivery).to receive(:deliver_later)
          end

          it 'Acceptation is notified by email' do
            expect(InitiativesMailer).to receive(:notify_state_change)
                                           .at_least(:once)
                                           .and_return(@message_delivery)
            published_initiative.accepted!
          end

          it 'Rejection is notified by email' do
            expect(InitiativesMailer).to receive(:notify_state_change)
                                           .at_least(:once)
                                           .and_return(@message_delivery)
            published_initiative.rejected!
          end
        end
      end

      context 'validating initiative' do
        let(:validating_initiative) {
          build(:initiative,
                state: 'validating',
                published_at: nil,
                signature_start_time: nil,
                signature_end_time: nil)
        }

        it 'is valid' do
          expect(validating_initiative).to be_valid
        end

        it 'publish!' do
          validating_initiative.publish!
          expect(validating_initiative).to have_signature_interval_defined
          expect(validating_initiative.published_at).not_to be_nil
        end

        context 'mailing' do
          before(:each) do
            @message_delivery = instance_double(ActionMailer::MessageDelivery)
            allow(@message_delivery).to receive(:deliver_later)
          end

          it 'publication is notified by email' do
            expect(InitiativesMailer).to receive(:notify_state_change)
                                           .at_least(:once)
                                           .and_return(@message_delivery)
            validating_initiative.published!
          end

          it 'Discard is notified by email' do
            expect(InitiativesMailer).to receive(:notify_state_change)
                                           .at_least(:once)
                                           .and_return(@message_delivery)
            validating_initiative.discarded!
          end
        end
      end
    end
  end
end
