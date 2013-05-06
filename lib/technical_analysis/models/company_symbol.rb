class CompanySymbol < ActiveRecord::Base
  self.table_name = :symbols
  attr_accessible :symbol
  belongs_to :company
end
