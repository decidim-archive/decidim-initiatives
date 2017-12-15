# frozen_string_literal: true

require "spec_helper"
require "decidim/admin/test/manage_attachments_examples"

describe "initiative attachments", type: :feature do
  include_context "initiative administration"

  let(:attached_to) { initiative }

  context "when managed by admin" do
    before do
      switch_to_host(organization.host)
      login_as user, scope: :user
      visit decidim_admin_initiatives.edit_initiative_path(initiative)
      click_link "Attachments"
    end

    it_behaves_like "manage attachments examples"
  end

  context "when managed by author" do
    before do
      switch_to_host(organization.host)
      login_as initiative.author, scope: :user
      visit decidim_admin_initiatives.edit_initiative_path(initiative)
      click_link "Attachments"
    end

    it_behaves_like "manage attachments examples"
  end
end
