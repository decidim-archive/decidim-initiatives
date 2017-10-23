# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe CreateInitiativeExtraData do
      let(:initiative) { create(:initiative, :created) }

      describe 'Author data' do
        let(:form) {
          ValidateInitiativeForm.from_params(initiative_author:
            {
              name: 'name',
              id_document: '00000000L',
              address: 'address',
              city: 'city',
              province: 'province',
              post_code: '00000',
              phone_number: '600000000'
            }
          ).with_context(
            initiative: initiative,
            data_type: 'author'
          )
        }

        let(:command) { described_class.new(form) }

        it 'broadcasts ok' do
          expect { command.call }.to broadcast :ok
        end

        it 'Creates an extra data record with author data' do
          expect do
            command.call
          end.to change { InitiativesExtraData.where(data_type: 'author').count }
        end

        it 'Called twice do not create duplicates' do
          expect do
            command.call
          end.to change { InitiativesExtraData.where(data_type: 'author').count }

          expect do
            command.call
          end.not_to change { InitiativesExtraData.where(data_type: 'author').count }
        end
      end

      describe 'Organization data' do
        let(:form) {
          OrganizationForm.from_params(organization_data:
            {
              name: 'name',
              id_document: '00000000L',
              address: 'address'
            }
          ).with_context(
            initiative: initiative,
            data_type: 'organization'
          )
        }

        let(:command) { described_class.new(form) }

        it 'broadcasts ok' do
          expect { command.call }.to broadcast :ok
        end

        it 'Creates an extra data record with organization data' do
          expect do
            command.call
          end.to change { InitiativesExtraData.where(data_type: 'organization').count }
        end

        it 'Called twice do not create duplicates' do
          expect do
            command.call
          end.to change { InitiativesExtraData.where(data_type: 'organization').count }

          expect do
            command.call
          end.not_to change { InitiativesExtraData.where(data_type: 'organization').count }
        end
      end
    end
  end
end
