module TechnicalAnalysis::Data
  class Candle
    attr_reader :open, :high, :low, :close, :datetime, :volume

    include TechnicalAnalysis::RiskManagement::Helpers
    include TechnicalAnalysis::Data::Helpers::Candle

    autoload :Quote, 'technical_analysis/data/candle/quote'

    def initialize(*vals)
      if vals.first.is_a?(Hash)
        update_attributes(vals.first)
      elsif not vals.empty?
        update_attributes(vals)
      end
    end

    def datetime=(val)
      if val.is_a?(String)
        @datetime = Time.parse(val)
      else
        @datetime = val
      end
    end

    def stop_loss
      super(high, low)
    end

    def method_missing(method, *params)
      if [:open=, :high=, :low=, :close=].include?(method)
        instance_variable_set("@#{method.to_s.chop}", Float(params.first)) unless params.first.nil?
      elsif [:time=, :date=, :datetime=].include?(method)
        instance_variable_set("@datetime", Time.parse(params.first))  unless params.first.nil?
      elsif method == :volume=
        instance_variable_set("@volume", Integer(params.first)) unless params.first.nil?
      else
        super
      end
    end

    def respond_to?(method)
      [:open=, :high=, :low=, :close=, :time=, :date=, :datetime=].include?(method) || super
    end

    alias :time :datetime
    alias :date :datetime

    def update_attributes(vals)
      raise ArgumentError.new('Hash or Array(datetime, open, high, low, close, volume) expected') unless [Hash, Array].include?(vals.class)
      if vals.is_a?(Array)
        self.datetime, self.open, self.high, self.low, self.close, self.volume = vals
      elsif vals.is_a?(Hash)
        [:open, :high, :low, :close, :volume, :date, :time, :datetime].each { |i| send("#{i}=", vals[i]) if send(i).nil? }
      end
    end
  end
end