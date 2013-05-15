class Portfolio < ActiveRecord::Base
  attr_accessible :cash, :risk_management_type, :name
  has_and_belongs_to_many :trade_with, :class_name => :Company
  has_many :trades
end
