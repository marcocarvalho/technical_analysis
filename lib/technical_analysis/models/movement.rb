class Movement < ActiveRecord::Base
  has_and_belongs_to_many :companies
end
