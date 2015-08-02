class CompanySymbol < ActiveRecord::Base
  self.table_name = :symbols
  belongs_to :company
end
