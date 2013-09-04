require 'technical_analysis'
require 'simplecov'

Dir[ File.join(File.dirname(__FILE__), '**/support/*.rb' )].each { |file| require file }

if(ENV["RUN_COVERAGE"])
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
  puts "Running coverage tool\n"
end
