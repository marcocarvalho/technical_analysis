class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.column :symbol, :string, :null => false
      t.column :period, :string, :null => false
      t.column :date,   :datetime, :null => false
      t.column :open,   :decimal
      t.column :high,   :decimal
      t.column :low,    :decimal
      t.column :close,  :decimal
      t.column :volume, :decimal
    end
  end

  def self.down
    drop_table :users
  end
end
