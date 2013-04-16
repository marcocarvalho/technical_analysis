module TechnicalAnalysis::RiskManagement
  module Helpers
    def profit_factor(gross_profit, gross_loss)
      gross_profit.to_f / gross_loss.to_f
    end
  end
end