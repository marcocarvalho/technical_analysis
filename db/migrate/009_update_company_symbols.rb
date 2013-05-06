class UpdateCompanySymbols < ActiveRecord::Migration
  def change
    add_column :symbols, :updated_at, :date
    add_column :symbols, :created_at, :date
  end
end