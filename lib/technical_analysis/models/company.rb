class Company < ActiveRecord::Base
  attr_accessible :name, :symbol, :cvm_id
  has_and_belongs_to_many :portfolios
  has_and_belongs_to_many :movements
end
