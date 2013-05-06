class Company < ActiveRecord::Base
  attr_accessible :name, :cvm_id
  has_and_belongs_to_many :portfolios
  has_and_belongs_to_many :movements
  has_and_belongs_to_many :dividends
  has_many :company_symbols, :dependent => :destroy

  def symbols
    company_symbols.map { |s| s.symbol }
  end

  def add_symbol(str)
    company_symbols << CompanySymbol.new(symbol: str)
  end
end
