# frozen_string_literal: true

require 'decidim/initiatives/admin'
require 'decidim/initiatives/engine'
require 'decidim/initiatives/admin_engine'
require 'decidim/initiatives/participatory_space'
require 'decidim/partial_translations_helper'

module Decidim
  # Base module for the initiatives engine.
  module Initiatives
    # Public setting that defines whether creation is allowed to any validated
    # user or not. Defaults to true.
    mattr_accessor :creation_enabled do
      true
    end

    # Public Setting that defines the similarity minimum value to consider two
    # initiatives similar. Defaults to 0.25.
    mattr_accessor :similarity_threshold do
      0.25
    end

    # Public Setting that defines how many similar initiatives will be shown.
    # Defaults to 5.
    mattr_accessor :similarity_limit do
      5
    end

    # Minimum number of committee members required to pass the initiative to
    # technical validation phase.
    mattr_accessor :minimum_committee_members do
      3
    end

    # Number of days available to collect supports after an initiative has been
    # published.
    mattr_accessor :default_signature_time_period_length do
      120
    end

    # Features enabled for a new initiative
    mattr_accessor :default_features do
      %i[pages results meetings surveys]
    end
  end
end
