# frozen_string_literal: true

require 'rails'
require 'active_support/all'
require 'decidim/core'

module Decidim
  module Initiatives
    # Decidim's Assemblies Rails Admin Engine.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Initiatives::Admin

      paths['db/migrate'] = nil

      routes do
        resources :initiatives_types, except: :show do
          resources :initiatives_type_scopes, except: %i[index show]
        end
        resources :initiatives, only: %i[index edit update] do
          member do
            get :send_to_technical_validation
            post :publish
            delete :unpublish
            delete :discard
          end

          resources :attachments, controller: 'initiative_attachments'

          resources :committee_requests, only: %i[index] do
            member do
              get :approve
              delete :revoke
            end
          end
        end

        scope '/initiatives/:initiative_id' do
          resources :features do
            resource :permissions, controller: 'feature_permissions'
            member do
              put :publish
              put :unpublish
            end
            resources :exports, only: :create
          end
        end

        scope '/initiatives/:initiative_id/features/:feature_id/manage' do
          Decidim.feature_manifests.each do |manifest|
            next unless manifest.admin_engine

            constraints CurrentFeature.new(manifest) do
              mount manifest.admin_engine, at: '/', as: "decidim_admin_initiative_#{manifest.name}"
            end
          end
        end
      end

      initializer 'admin_decidim_initiatives.assets' do |app|
        app.config.assets.precompile += %w[
            admin_decidim_initiatives_manifest.js
          ]
      end

      initializer 'decidim_assemblies.inject_abilities_to_user' do |_app|
        Decidim.configure do |config|
          config.admin_abilities += %w[
            Decidim::Initiatives::Abilities::Admin::InitiativeAdminAbility
            Decidim::Initiatives::Abilities::Admin::AttachmentsAbility
            Decidim::Initiatives::Abilities::Admin::FeaturesAbility
          ]
        end
      end

      initializer 'decidim_assemblies.admin_menu' do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t('menu.initiatives', scope: 'decidim.admin'),
                    decidim_admin_initiatives.initiatives_path,
                    icon_name: 'chat',
                    position: 3.7,
                    active: :inclusive,
                    if: can?(:index, Decidim::Initiative)
        end
      end
    end
  end
end
