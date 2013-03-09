# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/titan/version'

Gem::Specification.new do |gem|
  gem.name          = "guard-titan"
  gem.version       = Guard::TitanVersion::VERSION
  gem.authors       = ["David Conner"]
  gem.email         = ["dconner.pro@gmail.com"]
  gem.description   = %q{Run tests with Zeus using Guard Shell}
  gem.summary       = %q{Run tests with Zeus using Guard Shell}
  gem.homepage      = ""
  gem.license       = "LICENSE.txt"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
