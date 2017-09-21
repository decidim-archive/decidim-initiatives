# frozen_string_literal: true

require "decidim/initiatives/admin"
require "decidim/initiatives/engine"
require "decidim/initiatives/admin_engine"
require "decidim/initiatives/participatory_space"

module Decidim
  # Base module for the initiatives engine.
  module Initiatives
    # Public setting that defines whether creation is allowed to any validated user or not. Defaults to true.
    mattr_accessor :creation_enabled

    # Public Setting that defines the similarity minimum value to consider two initiatives similar. Defaults to 0.25.
    mattr_accessor :similarity_threshold

    # Public Setting that defines how many similar initatives will be shown. Defaults to 5.
    mattr_accessor :similarity_limit

    def self.creation_enabled
      @@creation_enabled || true
    end

    def self.similarity_threshold
      @@similarity_threshold || 0.25
    end

    def self.similarity_limit
      @@similarity_limit || 5
    end
  end
end
