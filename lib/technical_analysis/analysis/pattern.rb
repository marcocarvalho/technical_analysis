module TechnicalAnalysis::Analysis
  module Pattern
    def search_pattern(pattern)
    end
  end
end

Dir[ File.join(File.dirname(__FILE__), 'Pattern/*.rb' )].each { |file| require file }