module TechnicalAnalysis::Data
  module Helpers
    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end

Dir[ File.join(File.dirname(__FILE__), 'helpers/*.rb' )].each { |file| require file }