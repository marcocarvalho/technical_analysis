require 'singleton'

class HistoricalQuoteProxy
  include Singleton
  attr_accessor :symbol_in_cache, :symbol, :start, :finish, :cache

  def try_in_cache(method, method2, ret = nil)
    if cache.respond_to?(method) and cache.send(method).respond_to?(method2)
      cache.send(method).send(method2)
    else
      ret
    end
  end

  def symbol_in_cache
    try_in_cache(:first, :symbol, '')
  end

  def start_in_cache
    try_in_cache(:first, :date)
  end

  def finish_in_cache
    try_in_cache(:last, :date)
  end

  def parse_hash(hash)
    self.symbol = hash[:symbol]
    self.start  = parse_time(hash[:start])
    self.finish = parse_time(hash[:finish])
  end

  def parse_time(t)
    if t.is_a?(String)
      Time.parse(t)
    else
      t
    end
  end

  def load_quote(s, f, like = "")
    like1, like2 = like.split('')
    HistoricalQuote.where("symbol = ? and date >#{like1} ? and date <#{like2} ?", symbol, s, f).order(:date)
  end

  def refresh_cache?
    cache.nil? or symbol_in_cache != symbol
  end

  def append_cache_before?
    start_in_cache > start
  end

  def append_cache_after?
    finish_in_cache < finish
  end

  def refresh_cache
    self.cache  = load_quote(start, finish, '==')
    self.start  = start_in_cache
    self.finish = finish_in_cache
    return :refreshed
  end

  def append_cache(where)
    ret        = load_quote(start_in_cache, start, '= ')
    self.cache = where == :before ? ret + cache : cache + ret
    return "appended_#{where}".to_sym
  end

  def load_if_necessary
    if refresh_cache?
      refresh_cache
    elsif append_cache_before?
      append_cache(:before)
    elsif append_cache_after?
      append_cache(:after)
    end
  end

  def where(hash)
    parse_hash(hash)
    load_if_necessary
    cache
  end

  def self.where(opts)
    hq = instance
    hq.where(opts)
  end
end
