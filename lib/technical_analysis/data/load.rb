module TechnicalAnalysis::Data::LoadInterface
  def self.included(base)
    base.extend(ClassMethods)
  end
end

Dir[ File.join(File.dirname(__FILE__), 'load/*.rb' )].each { |file| require file }