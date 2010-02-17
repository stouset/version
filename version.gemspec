Gem::Specification.new do |s|
  s.name    = 'version'
  s.version = File.read('VERSION')
  s.summary = 'simple version-number encapsulation'
  
  s.author  = 'Stephen Touset'
  s.email   = 'stephen@touset.org'
  
  s.files   = Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*']
  
  s.extra_rdoc_files = Dir['*.rdoc']
  s.rdoc_options = %w{ --main README.rdoc }
  
  s.add_development_dependency 'rspec'
end
