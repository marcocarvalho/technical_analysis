module TechnicalAnalysis
  module Array    
    def execute_talib(name, *params)
      name = "ta_#{name.to_s.downcase}".to_sym
      if FFI::Talib.implemented_talib_methods.include?(name.to_sym)
        FFI::Talib.send(name, *params)
      else
        raise NotImplementedError.new("#{name} not implemented in FFI::Talib yet")
      end
    end

    def respond_to?(method)
      FFI::Talib.implemented_talib_methods.include?(method.to_sym) || super
    end

    def method_missing(method, *params)
      if FFI::Talib.implemented_talib_methods.include?(method.to_sym)
        execute_talib(method, self, *params)
      else
        super
      end
    end
  end
end
