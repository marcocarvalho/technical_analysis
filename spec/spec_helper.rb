require 'technical_analysis'
require 'simplecov'

SimpleCov.start

Dir[ File.join(File.dirname(__FILE__), '**/support/*.rb' )].each { |file| require file }
