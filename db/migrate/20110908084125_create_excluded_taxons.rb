class CreateExcludedTaxons < ActiveRecord::Migration
  def self.up
    create_table :excluded_taxons do |t|
      t.integer :taxon_id
      t.timestamps
    end
  end

  def self.down
    drop_table :excluded_taxons
  end
end
