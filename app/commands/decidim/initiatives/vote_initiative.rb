# frozen_string_literal: true

module Decidim
  module Initiatives
    # A command with all the business logic when a user or organization votes an initiative.
    class VoteInitiative < Rectify::Command
      # Public: Initializes the command.
      #
      # initiative     - A Decidim::Initiative object.
      # current_user - The current user.
      def initialize(initiative, current_user)
        @initiative = initiative
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the proposal vote.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        build_initiative_vote
        return broadcast(:invalid) unless vote.valid?

        vote.save!
        broadcast(:ok, vote)
      end

      attr_reader :vote

      private

      def build_initiative_vote
        @vote = @initiative.votes.build(author: @current_user, scope: 'votes')
      end
    end
  end
end
