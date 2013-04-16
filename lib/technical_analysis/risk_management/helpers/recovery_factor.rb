module TechnicalAnalysis::RiskManagement
  module Helpers
    def recovery_factor(net_profit, high_loss)
      net_profit.to_f / high_loss
    end
  end
end