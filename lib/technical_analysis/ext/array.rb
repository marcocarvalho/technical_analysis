module TechnicalAnalysis
  module Array
    def execute_talib(name, *params)
      name_send = "ta_#{name.to_s.downcase}".to_sym
      if Talib.implemented_talib_methods.include?(name.to_sym)
        Talib.send(name_send, *params)
      else
        raise NotImplementedError.new("#{name} not implemented in Talib yet")
      end
    end

    def respond_to?(method)
      Talib.implemented_talib_methods.include?(method.to_sym) || super
    end

    def method_missing(method, *params)
      if Talib.implemented_talib_methods.include?(method.to_sym)
        execute_talib(method, self, *params)
      else
        super
      end
    end
  end
end
