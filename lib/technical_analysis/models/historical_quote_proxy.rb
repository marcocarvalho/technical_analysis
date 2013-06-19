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
    HistoricalQuote.where("symbol = ? and date >#{like} ? and date <#{like} ?", symbol, s, f).order(:date)
  end

  def load_if_necessary
    if cache.nil? or symbol_in_cache != symbol
      self.cache  = load_quote(start, finish, '=')
      self.start  = start_in_cache
      self.finish = finish_in_cache
      return self.cache
    end

    if start_in_cache < start
      ret        = load_quote(start_in_cache, start)
      self.cache = ret + cache
      return self.cache
    end

    if finish_in_cache > finish
      ret        = load_quote(finish, finish_in_cache)
      self.cache = cache + ret
      return self.cache
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