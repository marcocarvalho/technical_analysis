class UpdatePortfolio < ActiveRecord::Migration
  def change
    add_column    :portfolios, :symbol,       :string
    add_column    :portfolios, :company_id,   :integer
    add_column    :portfolios, :initial_cash, :decimal, :precision => 20, :scale => 2
    change_column :portfolios, :cash,         :decimal, :precision => 20, :scale => 2
  end
end