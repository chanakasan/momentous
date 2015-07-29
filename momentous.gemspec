Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
  s.name        = 'momentous'
  s.version     = '0.2.0'
  s.date        = '2015-07-29'
  s.summary     = 'A library to work with business domain events.'
  s.description = 'This library is intended to help you decouple business logic of an app by allowing you to trigger and respond to domain events.'
  s.author      = 'Chanaka Sandaruwan'
  s.email       = 'chanakasan@gmail.com'
  s.files       = ['lib/momentous.rb']
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/chanakasan/momentous'
  s.license     = 'Apache License, Version 2.0'
end
