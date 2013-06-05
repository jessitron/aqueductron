Gem::Specification.new do |s|
  s.name        = 'aqueductron'
  s.version     = '0.0.1'
  s.date        = '2013-03-04'
  s.summary     = 'Dataflow in a functional, self-modifying pipeline style'
  s.description = 'Aqueductron lets you create a path for data, then flow data through it, then find the results at the end. It encourages a functional style, avoiding mutable values. It uses iteratees to let the path change itself as the data passes.'
  s.authors     = ['Jessica Kerr']
  s.email       = 'jessitron@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.license     = 'MIT'
  s.homepage    =
    'http://github.com/jessitron/aqueductron'
end

