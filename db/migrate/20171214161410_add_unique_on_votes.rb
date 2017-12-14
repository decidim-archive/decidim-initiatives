# frozen_string_literal: true

class AddUniqueOnVotes < ActiveRecord::Migration[5.1]
  def change
    add_index :decidim_initiatives_votes,
              %i[decidim_initiative_id decidim_author_id decidim_user_group_id],
              unique: true,
              name: 'decidim_initiatives_voutes_author_uniqueness_index'
  end
end
