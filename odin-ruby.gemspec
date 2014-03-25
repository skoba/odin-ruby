$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "odin/version"

Gem::Specification.new do |gem|
  gem.name = "odin"
  gem.version = Odin::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.authors = ["Shinji KOBAYASHI"]
  gem.email = "skoba@moss.gr.jp"

  gem.summary = "Ruby implementation of the openEHR ODIN"
  gem.description = "This project is an implementation of the openEHR ODIN specification on Ruby."
  gem.homepage = "http://openehr.jp"
  gem.license = "Apache 2.0"
  gem.extra_rdoc_files = [
    "README.md"
  ]
  gem.files         = `git ls-files -- lib/*`.split("\n")
  gem.files        += %w[README.md]
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_path  = "lib"

  gem.add_dependency('rake')
  gem.add_dependency('parslet')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('cucumber')
  # gem.add_development_dependency('guard')
  # gem.add_development_dependency('guard-rspec')
  # gem.add_development_dependency('guard-cucumber')
  # gem.add_development_dependency('spork', '> 1.0rc')
  # gem.add_development_dependency('guard-spork')
  # gem.add_development_dependency('simplecov')
  # gem.add_development_dependency('listen','0.6.0')
  # gem.add_development_dependency('libnotify')
end
