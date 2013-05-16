class Trade < ActiveRecord::Base
  attr_accessible :symbol, :date, :quantity, :type, :price, :brokerage, :subtotal, :total
  belongs_to :portfolio

  after_create do
    if type.to_sym == :buy
      portfolio.cash = portfolio.cash.to_f - total.to_f
    else type.to_sym == :sell
      portfolio.cash = portfolio.cash.to_f + total.to_f
    end
    portfolio.save
  end

  before_save do
    if subtotal.nil? or subtotal == 0
      self.subtotal = quantity * price
    end

    if total.nil? or total == 0
      self.total  = quantity * price - brokerage
    end
  end
end
