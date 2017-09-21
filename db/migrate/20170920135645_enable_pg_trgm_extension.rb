class EnablePgTrgmExtension < ActiveRecord::Migration[5.1]
  def up
    execute "CREATE EXTENSION pg_trgm;"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
