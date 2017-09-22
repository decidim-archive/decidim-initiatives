# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'decidim-initiatives'
  s.summary     = 'Citizen initiatives plugin for decidim'
  s.description = s.summary
  s.version     = '0.0.5'
  s.authors     = ['Juan Salvador Pérez García']
  s.email       = ['juan@aspgems.com']
  s.license     = 'AGPLv3'
  s.homepage    = 'https://github.com/AjuntamentdeBarcelona/decidim'
  s.required_ruby_version = '>= 2.3.1'

  s.files = Dir['{app,config,db,lib,vendor}/**/*', 'Rakefile', 'README.md']

  s.add_dependency 'decidim-core', '>= 0.6.0', '<= 0.8.0'
  s.add_dependency 'decidim-comments'
  s.add_dependency 'rectify', '~> 0.9.1'
  s.add_dependency 'kaminari', '~> 1.0.1'
  s.add_dependency 'truncato'
  s.add_dependency 'social-share-button', '~> 0.10.0'
  s.add_dependency 'wicked', '~> 1.3.2'

  s.add_development_dependency 'decidim-dev'
  s.add_development_dependency 'decidim-comments'
  s.add_development_dependency 'decidim-admin'
end
