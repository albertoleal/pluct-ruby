# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pluct/version'

Gem::Specification.new do |spec|
  spec.name          = "pluct"
  spec.version       = Pluct::VERSION
  spec.authors       = ["Alberto Leal"]
  spec.email         = ["albertonb@gmail.com"]
  spec.description   = %q{json-schema hypermedia client}
  spec.summary       = %q{json-schema hypermedia client}
  spec.homepage      = "http://github.com/albertoleal/pluct"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "hashie"
  spec.add_development_dependency "multi_json"
  spec.add_development_dependency "webmock"
  
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
