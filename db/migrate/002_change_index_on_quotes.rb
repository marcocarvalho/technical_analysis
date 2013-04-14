class ChangeIndexOnQuotes < ActiveRecord::Migration
  def change
    remove_index :quotes, [:symbol, :period]
    add_index :quotes, [:symbol, :date, :period], unique: true
  end
end
