class Trade < ActiveRecord::Base
  belongs_to :portfolio

  validates :symbol, :date, :quantity, :price, :type, presence: true
  validates :quantity, :price, numericality: true

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

  def self.inheritance_column
    :type_class
  end
end
