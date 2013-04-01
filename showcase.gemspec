# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'showcase/version'

Gem::Specification.new do |gem|
  gem.name          = "showcase"
  gem.version       = Showcase::VERSION
  gem.authors       = ["Stefano Verna"]
  gem.email         = ["stefano.verna@welaika.com"]
  gem.description   = %q{A barebone and framework agnostic presenter implementation}
  gem.summary       = %q{A barebone and framework agnostic presenter implementation}
  gem.homepage      = "https://github.com/welaika/showcase"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_development_dependency "rspec"
end
