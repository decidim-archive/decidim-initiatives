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
        resources :initiatives_types, except: :show
      end

      initializer 'decidim_assemblies.inject_abilities_to_user' do |_app|
        Decidim.configure do |config|
          config.admin_abilities += %w[
            Decidim::Initiatives::Abilities::Admin::AdminAbility
            Decidim::Initiatives::Abilities::Admin::OwnerAbility
          ]
        end
      end

      initializer 'decidim_assemblies.admin_menu' do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t('menu.initiatives_types', scope: 'decidim.admin'),
                    decidim_admin_initiatives.initiatives_types_path,
                    icon_name: 'dial',
                    position: 3.6,
                    active: :inclusive,
                    if: can?(:manage, Decidim::InitiativesType)
        end
      end
    end
  end
end
