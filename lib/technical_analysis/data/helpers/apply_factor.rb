module TechnicalAnalysis::Data
  module Helpers
    module Candle
      def apply_factor(factor)
        [:open, :high, :close, :low, :volume].each do |s|
          send("#{s}=", send(s).to_f * factor.to_f)
        end
      end
    end
  end
end