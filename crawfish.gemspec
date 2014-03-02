# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crawfish/version'

Gem::Specification.new do |spec|
  spec.name          = "crawfish"
  spec.version       = Crawfish::VERSION
  spec.authors       = ["Lance Woodson"]
  spec.email         = ["lance@webmaneuvers.com"]
  spec.summary       = %q{Crawfishing for active record models.  Yeehaw"}
  spec.description   = "Tree and flattened array data structures for traversing an ActiveRecord model graph"
  spec.homepage      = "https://github.com/lwoodson/crawfish"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency 'sqlite3', "~> 0"
  spec.add_development_dependency "pry", "~> 0"
  spec.add_runtime_dependency 'activerecord', '~> 3.1'
end
