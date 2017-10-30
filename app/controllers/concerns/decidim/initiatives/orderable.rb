# frozen_string_literal: true

require 'active_support/concern'

module Decidim
  module Initiatives
    # Common logic to ordering resources
    module Orderable
      extend ActiveSupport::Concern

      included do
        helper_method :order, :available_orders, :random_seed

        private

        # Gets how the proposals should be ordered based on the choice
        # made by the user.
        def order
          @order ||= detect_order(params[:order]) || default_order
        end

        def detect_order(candidate)
          available_orders.detect { |order| order == candidate }
        end

        # Available orders based on enabled settings
        def available_orders
          @available_orders ||= begin
            available_orders = %w[random recent most_voted most_commented]
            available_orders
          end
        end

        def default_order
          'random'
        end

        def reorder(proposals)
          case order
          when 'most_voted'
            proposals.order(created_at: :desc)
          when 'most_commented'
            proposals.order(created_at: :desc)
          when 'recent'
            proposals.order(created_at: :desc)
          else
            proposals.order_randomly(random_seed)
          end
        end

        # Returns: A random float number between -1 and 1 to be used as a
        # random seed at the database.
        def random_seed
          @random_seed ||= (params[:random_seed] ? params[:random_seed].to_f : (rand * 2 - 1))
        end
      end
    end
  end
end
