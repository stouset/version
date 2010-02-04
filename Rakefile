require 'rake/rdoctask'
require 'spec/rake/spectask'

Rake::RDocTask.new do |doc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  doc.title    = 'emcien-engine #{version}'
  doc.rdoc_dir = 'doc'
  doc.rdoc_files.include('README*')
  doc.rdoc_files.include('lib/**/*.rb')
end

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

task :default => :spec
