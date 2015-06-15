# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bulk_data_handler/version'

Gem::Specification.new do |spec|
  spec.name          = "bulk_data_handler"
  spec.version       = BulkDataHandler::VERSION
  spec.authors       = ["Grady Griffin"]
  spec.email         = ["ggriffin@carecloud.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{Extension for bulk data operations with ActiveRecord}
  spec.description   = %q{Extension for bulk data operations with ActiveRecord}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.2"

  spec.add_runtime_dependency "activerecord", ">= 3.0"
  spec.add_runtime_dependency "pg", '>= 0.18.0'
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pg", "~> 0.18"
  spec.add_development_dependency "factory_girl", "~> 4.3"
  spec.add_development_dependency "database_cleaner", "~> 1.4"
  spec.add_development_dependency "awesome_print", "~> 1.6"
  spec.add_development_dependency "pry", "~> 0.9.12"
end
