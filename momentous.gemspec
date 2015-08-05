Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
  s.name        = 'momentous'
  s.version     = '0.5.0'
  s.date        = '2015-08-05'
  s.summary     = 'A library for working with domain model events.'
  s.description = 'This library is intended to be useful for decoupling your business logic by allowing you to trigger and respond to domain model events.'
  s.author      = 'Chanaka Sandaruwan'
  s.email       = 'chanakasan@gmail.com'
  s.files       = ['lib/momentous.rb']
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/chanakasan/momentous'
  s.license     = 'Apache License, Version 2.0'
end
