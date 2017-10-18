namespace :decidim_initiatives do
  desc 'Check validating initiatives and moves all without changes for a configured time to discarded state'
  task check_validating: :environment do
    Decidim::Initiatives::OutdatedValidatingInitiatives
      .for(Decidim::Initiatives.max_time_in_validating_state)
      .each(&:discarded!)
  end

  desc 'Check published initiatives and moves to accepted/rejected state depending on the votes collected when the signing period has finished'
  task check_published: :environment do
    Decidim::Initiatives::SupportPeriodFinishedInitiatives.new.each do |initiative|
      supports_required = initiative.scoped_type.supports_required

      if initiative.initiative_votes_count >= supports_required
        initiative.accepted!
      else
        initiative.rejected!
      end
    end
  end
end
