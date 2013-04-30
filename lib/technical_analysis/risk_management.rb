module TechnicalAnalysis
  module RiskManagement
    autoload :Helpers, 'technical_analysis/risk_management/helpers'
    class Abstract
      attr_accessor :portfolio, :options

      def initialize(portf, opts = {})
        raise ArgumentError.new('Portfolio needed') unless portf.is_a?(Portfolio)
        @portfolio = portf
        @options   = opts
      end

      def quantity_or_value?
        # must return :quantity or :value
        raise NotImplementedError.new('implement this!')
      end

      def quantity
        raise NotImplementedError.new('implement this!')
      end

      def value
        raise NotImplementedError.new('implement this!')
      end

      def self.setup
        # should return options and their possibilities as a hash
        # { :option1 => [1,2,3,4], max_loss: [0.02, 0.04, 0.06, 0.08, 0.1] }
        # this method permits automatic setup test with all possible parameters
        raise NotImplementedError.new('implement this!')
      end

      def self.extended(klass)
        @classes ||= []
        @classes << klass
      end
    end
  end
end

Dir[ File.join(File.dirname(__FILE__), 'risk_management/*.rb' )].each { |file| require file }
Dir[ File.join(File.dirname(__FILE__), 'risk_management/antimartingale/*.rb' )].each { |file| require file }