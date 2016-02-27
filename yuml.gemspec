Gem::Specification.new do |s|
  s.name        = 'yuml'
  s.version     = '0.4.0'
  s.date        = '2016-02-27'
  s.summary     = 'A Ruby DSL for generating UML'
  s.description = 'A Ruby DSL for generating UML built on yuml.me'
  s.authors     = ['Derek Stride']
  s.email       = 'djgstride@gmail.com'
  s.files       = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'https://github.com/DerekStride/yuml'
  s.license     = 'MIT'
  s.add_development_dependency 'rspec', '~> 3.4'
end
