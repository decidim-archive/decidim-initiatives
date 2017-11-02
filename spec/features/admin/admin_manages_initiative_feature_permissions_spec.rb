# frozen_string_literal: true

require 'spec_helper'
require 'decidim/admin/test/manage_feature_permissions_examples'
require 'generators/decidim/templates/decidim/dummy_authorization_handler'

describe 'Admin manages initiative feature permissions', type: :feature do
  include_examples 'Managing feature permissions' do
    let(:participatory_space_engine) { decidim_admin_initiatives }

    let!(:participatory_space) do
      create(:initiative, organization: organization)
    end
  end
end