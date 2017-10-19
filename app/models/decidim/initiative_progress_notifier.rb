# frozen_string_literal: true

module Decidim
  class InitiativeProgressNotifier
    attr_reader :initiative

    def initialize(args = {})
      @initiative = args.fetch(:initiative)
    end

    def notify
      initiative.followers.each do |follower|
        Decidim::Initiatives::InitiativesMailer
          .notify_progress(initiative, follower)
          .deliver_later
      end

      initiative.committee_members.approved.each do |committee_member|
        Decidim::Initiatives::InitiativesMailer
          .notify_progress(initiative, committee_member.user)
          .deliver_later
      end

      Decidim::Initiatives::InitiativesMailer
        .notify_progress(initiative, initiative.author)
        .deliver_later
    end
  end
end