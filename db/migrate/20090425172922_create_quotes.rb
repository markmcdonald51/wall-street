class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.integer :stock_id
      t.float :ask
      t.float :bid
      t.datetime :date

      t.timestamps
    end
    add_index :quotes, [:stock_id, :created_at]
  end

  def self.down
    drop_table :quotes
  end
end
