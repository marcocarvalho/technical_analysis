class Trade < ActiveRecord::Base
  attr_accessible :symbol, :date, :quantity, :type, :price, :brokerage, :subtotal, :total
  belongs_to :portfolio
end
