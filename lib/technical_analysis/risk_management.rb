module TechnicalAnalysis
  module RiskManagement
    autoload :Helpers, 'technical_analysis/risk_management/helpers'
    class Abstract
      attr_accessor :portfolio, :options

      def initialize(opts = {})
        @options   = opts
      end

      def trade?(cash, price_in, opts = {})
        raise NotImplementedError.new('implement this!')
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

      def self.inherited(klass)
        @classes ||= []
        @classes << klass
      end

      def self.list
        @classes
      end
    end

    def self.list
      Abstract.list
    end
  end
end

Dir[ File.join(File.dirname(__FILE__), 'risk_management/*.rb' )].each { |file| require file }
Dir[ File.join(File.dirname(__FILE__), 'risk_management/antimartingale/*.rb' )].each { |file| require file }