class AddIndexOnHistoricalQuote < ActiveRecord::Migration
  def change
    add_index :historical_quotes, :date
  end
end