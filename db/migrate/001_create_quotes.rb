class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :symbol, :null => false
      t.string :period, :null => false
      t.datetime :date, :null => false
      t.decimal :open
      t.decimal :high
      t.decimal :low
      t.decimal :close
      t.decimal :volume

      t.timestamps
    end

    add_index :quotes, [:symbol, :period]
  end
end
