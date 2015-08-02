# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'technical_analysis/version'

Gem::Specification.new do |spec|
  spec.name          = "technical_analysis"
  spec.version       = TechnicalAnalysis::VERSION
  spec.authors       = ["Marco Carvalho"]
  spec.email         = ["marco.carvalho.swasthya@gmail.com"]
  spec.description   = %q{Technical Analysis Gem}
  spec.summary       = %q{Under construction}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency 'nas-yahoo_stock'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'activerecord'
  spec.add_dependency 'pg'
  spec.add_dependency 'activerecord-import'

  #spec.add_dependency 'ffi-talib', "~> 0.1"  # in the future
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "rake"

  # test stuff
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fuubar'

  # run tests automatically
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'growl'

  # for documentation
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'

  # for code coverage
  spec.add_development_dependency 'simplecov'
end
