class CreateLsiAnalyses < ActiveRecord::Migration
  def self.up
    create_table :lsi_analyses do |t|
      t.string :jobid, :limit => 9
      t.timestamps
    end
  end

  def self.down
    drop_table :lsi_analyses
  end
end
