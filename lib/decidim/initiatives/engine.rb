# frozen_string_literal: true

require 'rails'
require 'active_support/all'
require 'decidim/core'

module Decidim
  module Initiatives
    # Decidim's Initiatives Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Initiatives

      routes do
        resources :create_initiative
        resources :initiatives, only: %i[index show] do
          member do
            get :send_to_technical_validation
          end

          resource :initiative_vote, only: %i[create destroy]
          resource :initiative_widget, only: :show, path: 'embed'
          resources :committee_requests, only: %i[new], shallow: true do
            collection do
              get :spawn
            end

            member do
              get :approve
              delete :revoke
            end
          end
        end
      end

      initializer 'decidim_initiatives.assets' do |app|
        app.config.assets.precompile += %w[
          decidim_initiatives_manifest.js
        ]
      end

      initializer 'decidim_initiatives.inject_abilities_to_user' do |_app|
        Decidim.configure do |config|
          config.abilities += %w[
            Decidim::Initiatives::Abilities::EveryoneAbility
            Decidim::Initiatives::Abilities::CurrentUserAbility
          ]
        end
      end

      initializer 'decidim_assemblies.menu' do
        Decidim.menu :menu do |menu|
          menu.item I18n.t('menu.initiatives', scope: 'decidim'),
                    decidim_initiatives.initiatives_path,
                    position: 2.6,
                    active: :inclusive
        end
      end
    end
  end
end
