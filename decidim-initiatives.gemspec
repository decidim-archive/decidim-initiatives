# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __FILE__)

require "decidim/initiatives/version"

Gem::Specification.new do |s|
  s.name = "decidim-initiatives"
  s.summary = "Citizen initiatives plugin for decidim"
  s.description = s.summary
  s.version = Decidim::Initiatives::VERSION
  s.authors = ["Juan Salvador Perez Garcia"]
  s.email = ["jsperezg@gmail.com"]
  s.license = "AGPLv3"
  s.homepage = "https://github.com/AjuntamentdeBarcelona/decidim"
  s.required_ruby_version = ">= 2.3.1"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "Rakefile", "README.md", "LICENSE-AGPLv3.txt"]

  s.add_dependency "decidim-admin"
  s.add_dependency "decidim-comments"
  s.add_dependency "decidim-core", ">= 0.8.4", "< 0.10.0"
  s.add_dependency "decidim-verifications"
  s.add_dependency "kaminari", "~> 1.0.1"
  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "rectify"
  s.add_dependency "social-share-button", "~> 1.0.0"
  s.add_dependency "truncato"
  s.add_dependency "wicked"

  s.add_development_dependency "decidim-dev", ">= 0.8.4", "< 0.10.0"
end
