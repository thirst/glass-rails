# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glass/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "glass-rails"
  spec.version       = Glass::Rails::VERSION
  spec.authors       = ["Kunal Modi", "Han Kang"]
  spec.email         = ["kunal@thirstlabs.com", 'han@therubyists.org']
  spec.description   = %q{ A framework for creating google glass applications using ruby on rails. }
  spec.summary       = %q{ A framework for creating google glass applications using ruby on rails. 
                          This probably isn't for everyone, but we did our best to make it suitable for
                          as many cases as possible. }
  spec.homepage      = "http://thirst.github.io/glass-rails/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "railties", [">= 3.1"]
  spec.add_dependency "google-api-client"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "rspec", ">= 1.5.2"
  spec.add_development_dependency "rspec-rails", '~> 2.11.0'

end
