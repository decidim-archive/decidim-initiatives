# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Initiatives
    describe CreateInitiative do
      let(:form_klass) { InitiativeForm }

      context 'Happy path' do
        it_behaves_like 'create an initiative'
      end

      context 'invalid data' do
        let(:organization) { create(:organization) }
        let(:initiative) { create(:initiative, organization: organization) }
        let(:form) {
          form_klass
            .from_model(initiative)
            .with_context(
              current_organization: organization
            )
        }

        let(:command) { described_class.new(form, initiative.author) }

        it 'broadcasts invalid' do
          expect_any_instance_of(Initiative).to receive(:persisted?)
                                                  .at_least(:once)
                                                  .and_return(false)
          expect { command.call }.to broadcast :invalid
        end
      end
    end
  end
end