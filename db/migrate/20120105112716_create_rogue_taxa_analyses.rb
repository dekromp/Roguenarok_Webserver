class CreateRogueTaxaAnalyses < ActiveRecord::Migration
  def self.up
    create_table :rogue_taxa_analyses do |t|
      t.integer :jobid, :limit => 9
      t.timestamps
    end
  end

  def self.down
    drop_table :rogue_taxa_analyses
  end
end
