# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_sql/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_sql"
  spec.version       = HashSql::VERSION
  spec.authors       = ["nicknux"]
  spec.email         = ["code@nickdsantos.com"]
  spec.summary       = %q{Create SQL statements using Hashes.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec'    
end
