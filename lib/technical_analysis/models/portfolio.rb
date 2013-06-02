class Portfolio < ActiveRecord::Base
  attr_accessible :cash, :risk_management_type, :name
  has_and_belongs_to_many :trade_with, :class_name => :Company
  has_many :trades, :dependent => :destroy

  def sell(opts = {})
    hash = { type: :sell, brokerage: 0, date: Time.now }.merge(opts)
    trades.create(hash)
  end

  def buy(opts = {})
    hash = { type: :buy, brokerage: 0, date: Time.now }.merge(opts)
    trades.create(hash)
  end
end
