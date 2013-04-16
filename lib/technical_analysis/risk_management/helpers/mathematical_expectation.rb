module TechnicalAnalysis::RiskManagement
  module Helpers
    def mathematical_expectation(avg_profit, avg_loss, win_rate)
      ( 1 + ( avg_profit.to_f / avg_loss.to_f ) * win_rate.to_f ) - 1
    end
  end
end