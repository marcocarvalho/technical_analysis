module TechnicalAnalysis
  module RiskManagement
    class Classic < Abstract
      # Max Risk share

      attr_accessor :stop_gain, :stop_loss, :max_loss, :trade_at, :type, :cash

      def initialize(opts = {})
        super
        parse_opts(opts)
      end

      def parse_opts(opts)
        @stop_loss = opts[:stop_loss] || @stop_loss
        @max_loss  = opts[:max_loss]  || @max_loss  || 0.08
        @type      = opts[:type]      || @type      || :buy
      end

      def self.setup
        { max_loss: [0.02, 0.04, 0.06, 0.08, 0.1] }
      end

      def quantity_or_value?
        :quantity
      end

      def max_risk
        (cash.to_f * max_loss)
      end

      def quantity
        risk = max_risk / (trade_at - stop_loss)
        if risk * trade_at > cash.to_f
          (cash.to_f / trade_at.to_f).to_i
        else
          risk.to_i
        end
      end

      def value
        trade_at * quantity
      end

      def trade?(cash, price_in, opts = {})
        return false if not price_in.kind_of?(Numeric) or
                        not cash.kind_of?(Numeric) or
                        not opts[:stop_loss].kind_of?(Numeric)
        @trade_at  = price_in
        @cash      = cash
        parse_opts(opts)
        quantity > 0
      end
    end
  end
end