Gem::Specification.new do |s|
  s.name        = 'yuml'
  s.version     = '0.3.0'
  s.date        = '2016-02-20'
  s.summary     = 'A Ruby DSL for generating UML'
  s.description = 'A Ruby DSL for generating UML built on yuml.me'
  s.authors     = ['Derek Stride']
  s.email       = 'djgstride@gmail.com'
  s.files       = ['lib/yuml.rb', 'lib/yuml/class.rb', 'lib/yuml/relationship.rb']
  s.homepage    = 'https://github.com/DerekStride/yuml'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.4'
end
