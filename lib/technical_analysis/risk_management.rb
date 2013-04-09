module TechnicalAnalysis
  module RiskManagement
  end
end

Dir[ File.join(File.dirname(__FILE__), 'risk_management/*.rb' )].each { |file| require file }