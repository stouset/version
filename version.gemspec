# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "version"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Touset"]
  s.date = "2012-09-26"
  s.email = "stephen@touset.org"
  s.extra_rdoc_files = ["History.rdoc", "README.rdoc", "TODO.rdoc"]
  s.files = ["Gemfile", "Gemfile.lock", "History.rdoc", "License.txt", "Rakefile", "README.rdoc", "TODO.rdoc", "VERSION", "lib/rake/version_task.rb", "lib/version/component.rb", "lib/version/ext/array.rb", "lib/version/ext/hash.rb", "lib/version/ext/module.rb", "lib/version/ext/string.rb", "lib/version.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/version_spec.rb"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "simple version-number encapsulation"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>, ["~> 2.11"])
    else
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rspec>, ["~> 2.11"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rspec>, ["~> 2.11"])
  end
end
