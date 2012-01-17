class CreateRoguenaroks < ActiveRecord::Migration
  def self.up
    create_table :roguenaroks do |t|
      t.integer :user_id
      t.string :jobid, :limit => 9
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :roguenaroks
  end
end
