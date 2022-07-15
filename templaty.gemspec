# frozen_string_literal: true

require_relative 'lib/templaty/version'

Gem::Specification.new do |spec|
  spec.author           = 'Washington Botelho'
  spec.description      = 'Rails template generator.'
  spec.email            = 'wbotelhos@gmail.com'
  spec.extra_rdoc_files = Dir['CHANGELOG.md', 'LICENSE', 'README.md']
  spec.files            = Dir['lib/**/*']
  spec.homepage         = 'https://github.com/wbotelhos/templaty'
  spec.license          = 'MIT'
  spec.name             = 'templaty'
  spec.summary          = 'Rails template generator.'
  spec.version          = Templaty::VERSION

  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'rubocop-rspec'
end
