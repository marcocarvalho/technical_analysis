class Dividend < ActiveRecord::Base
  attr_accessible :earning_type, :deliberated_at, :ex_at, :ordinary_payment, :prefered_payment, :related_at, :credit_at, :obs
  has_and_belongs_to_many :companies
end