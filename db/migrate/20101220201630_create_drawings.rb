class CreateDrawings < ActiveRecord::Migration
  def self.up
    create_table :drawings do |t|
      t.integer :thread
      t.integer :user
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end

  def self.down
    drop_table :drawings
  end
end
