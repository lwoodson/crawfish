# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'entitree/version'

Gem::Specification.new do |spec|
  spec.name          = "entitree"
  spec.version       = Entitree::VERSION
  spec.authors       = ["Lance Woodson"]
  spec.email         = ["lance@webmaneuvers.com"]
  spec.summary       = %q{Allows entity tree traversal and visitor operations within ActiveRecord models}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency "pry"
  spec.add_runtime_dependency 'activerecord', '>3.1'
end
