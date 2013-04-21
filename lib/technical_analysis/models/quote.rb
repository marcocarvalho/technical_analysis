class Quote < ActiveRecord::Base
  validates :symbol, uniqueness: { scope: [:date, :period], message: 'quote already exists' }
end