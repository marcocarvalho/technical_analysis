class Company < ActiveRecord::Base
  attr_accessible :name, :symbol
  has_and_belongs_to_many :portfolios
end
