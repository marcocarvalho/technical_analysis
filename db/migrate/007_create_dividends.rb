class CreateDividends < ActiveRecord::Migration
  def change
    create_table :dividends do |t|
      t.string :earning_type, :null => false
      t.date   :deliberated_at
      t.date   :ex_at,            :null => true
      t.float  :ordinary_payment
      t.float  :prefered_payment
      t.string :related_at
      t.date   :credit_at
      t.string :obs

      t.timestamps
    end

    create_table :companies_dividends do |t|
      t.references :dividend
      t.references :company
    end

    add_index :companies_dividends, [:dividend_id, :company_id]
  end
end

# { type: type,
#   deliberated_at: deliberated_at,
#   ex_at: ex_at,
#   ordinary_payment: ordinarias,
#   prefered_payment: preferencias,
#   related_at: related_at,
#   credit_at: credit_at,
#   obs: obs }