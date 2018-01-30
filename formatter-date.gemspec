lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formatter/date/version'

Gem::Specification.new do |spec|
  spec.name          = 'formatter-date'
  spec.version       = Formatter::Date::VERSION
  spec.authors       = ['Terje Larsen']
  spec.email         = 'terlar@gmail.com'
  spec.summary       = 'Date formatter with time zone support'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/terlar/formatter-date'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]
  spec.extra_rdoc_files = %w[LICENSE README.md]

  spec.required_ruby_version = '>= 2.1'

  spec.add_runtime_dependency 'tzinfo', '~> 1.2.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.52'
end
