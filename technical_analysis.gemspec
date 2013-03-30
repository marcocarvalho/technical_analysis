# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'technical_analysis/version'

Gem::Specification.new do |spec|
  spec.name          = "technical_analysis"
  spec.version       = TechnicalAnalysis::VERSION
  spec.authors       = ["Marco Carvalho"]
  spec.email         = ["marco.carvalho.swasthya@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'ffi-talib', "~> 0.1"  # in the future
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
