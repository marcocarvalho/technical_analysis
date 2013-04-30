module TechnicalAnalysis
  module RiskManagement
    class Classic < Abstract
      # Max Risk share

      attr_accessor :stop_loss, :max_loss, :trade_at, :type

      def initialize(*args)
        super(*args)
        @stop_loss = options[:stop_loss]
        @max_loss  = options[:max_loss] || 0.08
        @trade_at  = options[:trade_at]
        @type      = options[:type] || :buy
      end

      def self.setup
        { max_loss: [0.02, 0.04, 0.06, 0.08, 0.1] }
      end

      def quantity_or_value?
        :quantity
      end

      def max_risk
        (portfolio.cash * max_loss)
      end

      def quantity
        max_risk / (trade_at - stop_loss)
      end

      def value
        trade_at * quantity
      end
    end
  end
end