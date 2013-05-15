module TechnicalAnalysis
  class LastMaximumDisruption < Setup
    def trade?(price, idx = nil)
      if idx
        candle_array[idx].high < price
      else
        candle_array.last.high < price
      end
    end

    def stop_loss(idx = nil)
      if idx
        candle_array[idx].low.round(2)
      else
        candle_array.last.low.round(2)
      end
    end

    def stop_gain(idx = nil)
      if idx
        (candle_array[idx].high * 1.07).round(2)
      else
        (candle_array.last.high * 1.07).round(2)
      end
    end

    def entry_point?(now, last)
      last.high < now.high
    end

    def stops(type)
      if type == :loss
        @stops_losses ||= { }
      else
        @stops_gains ||= { }
      end
    end

    # TODO: brokerage needed. Probaly this values should be in portfolio
    def brokerage
      0
    end

    def log_trade(trade, trade_out)
      #save stuff
    end

    def portfolio
      riskmanagement.portfolio
    end

    def close_stops(idx)
      delete = []
      now = candle_array[idx]

      block = Proc.new do |key, trade|
        if (now.low..now.high).include?(key)
          trade_at  = price_near(key, price_tolerance: 0.01)
          trade_out = portfolio.trades.create(
               symbol:    trade.symbol,
               date:      now.date,
               quantity:  trade.quantity,
               type:      :sell,
               price:     trade_at,
               brokerage: brokerage,
               subtotal:  trade.quantity * trade_at,
               total:     trade.quantity * trade_at + brokerage)
          log_trade(trade, trade_out)
          delete << key
        end
      end

      stops(:loss).each &block
      stops(:loss).delete_if { |k, _| delete.include?(k) }

      delete = []
      stops(:gain).each &block
      stops(:gain).delete_if { |k, _| delete.include?(k) }
    end

    def run_setup
      candle_array.each_index do |idx|
        next if idx == 0
        last = candle_array[idx - 1]
        now  = candle_array[idx]

        close_stops(idx)

        if entry_point?(now, last)
          riskmanagement.stop_loss = stop_loss(idx)
          riskmanagement.stop_gain = stop_gain(idx)
          riskmanagement.trade_at  = price_below(now, :high)
          if riskmanagement.trade?
            trade     = portfolio.trades.create(
                           symbol:    now.symbol,
                           date:      now.date,
                           quantity:  riskmanagement.quantity,
                           type:      :buy,
                           price:     riskmanagement.trade_at,
                           brokerage: brokerage,
                           subtotal:  riskmanagement.quantity * riskmanagement.trade_at,
                           total:     riskmanagement.quantity * riskmanagement.trade_at + brokerage)
            stops(:loss)[stop_loss(idx)] = trade
            stops(:gain)[stop_gain(idx)] = trade
          end
        end
      end
    end
  end
end