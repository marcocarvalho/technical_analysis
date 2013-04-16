module TechnicalAnalysis
  module RiskManagement
    def stop_loss(max, min)
      max - ( (max - min) * 1.33 )
    end
  end
end