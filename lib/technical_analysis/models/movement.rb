class Movement < ActiveRecord::Base
  attr_accessible :earning_type, :deliberated_at, :ex_at, :factor, :credit_at, :obs, :kind
  has_and_belongs_to_many :companies
end