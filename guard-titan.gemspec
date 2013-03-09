# -*- encoding: utf-8 -*-
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require File.expand_path('../lib/guard/titan', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "guard-titan"
  gem.version       = Guard::Titan::VERSION
  gem.authors       = ["David Conner"]
  gem.email         = ["dconner.pro@gmail.com"]
  gem.description   = %q{Run tests with Zeus using Guard Shell}
  gem.summary       = %q{Run tests with Zeus using Guard Shell}
  gem.homepage      = ""
  gem.license       = "LICENSE.txt"

  gem.add_dependency 'guard', '>= 0.2.0'
  gem.add_dependency 'guard-shell', '>= 0.5.0'

  gem.files        = %w(Readme.md LICENSE.txt)
  gem.files       += Dir["{lib}/**/*"]

  #gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
end
