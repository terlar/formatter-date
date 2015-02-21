# encoding: utf-8

require File.expand_path('../lib/formatter/date/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'formatter-date'
  gem.version       = Formatter::Date::VERSION.dup
  gem.authors       = ['Terje Larsen']
  gem.email         = 'terlar@gmail.com'
  gem.description   = 'Date formatter with time zone support'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/terlar/formatter-date'
  gem.license       = 'MIT'

  gem.require_paths = %w(lib)
  gem.files         = `git ls-files`.split($RS)
  gem.test_files    = gem.files.grep(/^test\//)
  gem.extra_rdoc_files = %w(LICENSE README.md)

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_runtime_dependency 'tzinfo'

  gem.add_development_dependency 'bundler', '~> 1.6'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rubocop'
end
