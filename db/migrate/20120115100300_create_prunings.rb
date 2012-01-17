class CreatePrunings < ActiveRecord::Migration
  def self.up
    create_table :prunings do |t|
      t.string :jobid, :limit => 9
      t.timestamps
    end
  end

  def self.down
    drop_table :prunings
  end
end
