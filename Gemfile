source 'https://rubygems.org'

# Specify your gem's dependencies in technical_analysis.gemspec
if ENV['RACK_ENV'] != 'production'
  gem 'ffi-talib', "~> 0.1.1", :path => '/home/marco/desenv/talib-ffi-wrapper' #:git => 'git://github.com/marcocarvalho/ffi-talib.git'
else
  gem 'ffi-talib', "~> 0.1.1", :git => 'git://github.com/marcocarvalho/ffi-talib.git'
end
gem 'capistrano'
gemspec
