class CreatePortfolio < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :cash, :null => false
      t.string :name, :null => true
      t.string :risk_management_type, :null => false

      t.timestamps
    end

    create_table :companies_portfolios do |t|
      t.references :portfolio
      t.references :company
    end

    add_index :companies_portfolios, [:portfolio_id, :company_id]
  end
end
