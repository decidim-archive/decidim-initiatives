# frozen_string_literal: true

require 'spec_helper'

describe 'rake decidim_initiatives:check_validating', type: :task do
  let(:threshold) { DateTime.now - Decidim::Initiatives.max_time_in_validating_state }

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully' do
    expect { task.execute }.not_to raise_error
  end

  context 'Initiatives without changes' do
    let(:initiative) { create(:initiative, :validating, updated_at: DateTime.now - 1.year) }

    it 'Are marked as discarded' do
      expect(initiative.updated_at).to be < threshold
      task.execute

      initiative.reload
      expect(initiative).to be_discarded
    end
  end

  context 'Initiatives with changes' do
    let(:initiative) { create(:initiative, :validating) }

    it 'remain unchanged' do
      expect(initiative.updated_at).to be >= threshold
      task.execute

      initiative.reload
      expect(initiative).to be_validating
    end
  end
end