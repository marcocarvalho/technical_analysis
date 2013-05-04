class CreateHistoricalQuote < ActiveRecord::Migration
  def change
    create_table :historical_quotes do |t|
      t.string   :symbol,   :null => false
      t.string   :period,   :null => false
      t.datetime :date,     :null => false
      t.decimal  :open,     :precision => 20, :scale => 2
      t.decimal  :high,     :precision => 20, :scale => 2
      t.decimal  :low,      :precision => 20, :scale => 2
      t.decimal  :close,    :precision => 20, :scale => 2
      t.decimal  :volume,   :precision => 20, :scale => 2
      t.integer  :operations

      t.timestamps
    end

    add_index :historical_quotes, [:symbol, :period]
  end
end
