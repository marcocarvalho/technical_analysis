class Company < ActiveRecord::Base
  attr_accessible :name, :cvm_id
  has_and_belongs_to_many :portfolios
  has_and_belongs_to_many :movements
  has_and_belongs_to_many :dividends
  has_many :symbols, :class_name => :CompanySymbol
end
