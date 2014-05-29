# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'radriar/version'

Gem::Specification.new do |spec|
  spec.name          = "radriar"
  spec.version       = Radriar::VERSION
  spec.authors       = ["Adrian Perez"]
  spec.email         = ["adrianperez.deb@gmail.com"]
  spec.summary       = %q{Opinionated set of tools for Ruby API development}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/blackxored/radriar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.0"

  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_dependency "representable", ">= 1.8.0"
  spec.add_dependency "grape"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", ">= 3.0.0.rc1"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rr"
  spec.add_development_dependency "grape-bugsnag"
  spec.add_development_dependency "garner"
end
