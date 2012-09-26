$: << 'lib'

require 'rake/version_task'

require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rspec/core/rake_task'

spec = Gem::Specification.new do |s|
  s.name    = 'version'
  s.version = Version.current or '0.0.0'
  s.summary = 'simple version-number encapsulation'
  
  s.author  = 'Stephen Touset'
  s.email   = 'stephen@touset.org'
  
  s.files   = Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*']
  
  s.extra_rdoc_files = Dir['*.rdoc']
  s.rdoc_options = %w{ --main README.rdoc }
  
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'rspec', '~> 2.11'
end

Rake::GemPackageTask.new(spec) do |gem|
  gem.need_tar = true
end

Rake::RDocTask.new do |doc|
  doc.title    = "version #{Version.current}"
  doc.rdoc_dir = 'doc'
  doc.main     = 'README.rdoc'
  doc.rdoc_files.include('*.rdoc')
  doc.rdoc_files.include('lib/**/*.rb')
end

desc "Run specs"
RSpec::Core::RakeTask.new

Rake::VersionTask.new do |v|
  v.with_git_tag = true
  v.with_gemspec = spec
end

task :default => :spec
