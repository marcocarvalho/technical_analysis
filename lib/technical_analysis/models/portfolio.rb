class Portfolio < ActiveRecord::Base
  belongs_to :company
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
