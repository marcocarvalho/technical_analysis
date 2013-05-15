class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string     :symbol
      t.datetime   :date
      t.integer    :quantity
      t.string     :type,      limit: 1
      t.decimal    :price,     precision: 20, scale: 2
      t.decimal    :brokerage, precision: 20, scale: 2
      t.decimal    :subtotal,  precision: 20, scale: 2
      t.decimal    :total,     precision: 20, scale: 2
      t.references :portfolio, :null => false
    end

    add_index :trades, :portfolio_id
    add_index :trades, [:portfolio_id, :type]
    add_index :trades, [:portfolio_id, :date]
  end
end
