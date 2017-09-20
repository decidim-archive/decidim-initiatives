# frozen_string_literal: true

require "decidim/initiatives/admin"
require "decidim/initiatives/engine"
require "decidim/initiatives/admin_engine"
require "decidim/initiatives/participatory_space"

module Decidim
  # Base module for the initiatives engine.
  module Initiatives
    # Public setting that defines whether creation is allowed to any validated user or not.
    mattr_accessor :creation_enabled

    def self.creation_enabled
      @@creation_enabled || true
    end
  end
end
