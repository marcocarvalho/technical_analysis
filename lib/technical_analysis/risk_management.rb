module TechnicalAnalysis
  module RiskManagement
    autoload :Helpers, 'technical_analysis/risk_management/helpers'
    class Abstract
      def self.extended(klass)
        @classes ||= []
        @classes << klass
      end
    end
  end
end

Dir[ File.join(File.dirname(__FILE__), 'risk_management/*.rb' )].each { |file| require file }