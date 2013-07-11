# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rcsw/version'

Gem::Specification.new do |spec|
  spec.name          = "rcsw"
  spec.version       = RCSW::VERSION
  spec.authors       = ["Will Fisher"]
  spec.email         = ["will@teknofire.net"]
  spec.description   = %q{Ruby parser for OGC CSW requests}
  spec.summary       = %q{Ruby parser for OGC CSW requests}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency  "libxml-ruby"
  spec.add_dependency  "curb"
end
