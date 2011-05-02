# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{version}
  s.version = "1.0.0a"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Touset"]
  s.date = %q{2011-05-02}
  s.email = %q{stephen@touset.org}
  s.extra_rdoc_files = ["History.rdoc", "README.rdoc", "TODO.rdoc"]
  s.files = ["History.rdoc", "License.txt", "Rakefile", "README.rdoc", "TODO.rdoc", "VERSION", "lib/rake/version_task.rb", "lib/version/component.rb", "lib/version/ext/array.rb", "lib/version/ext/hash.rb", "lib/version/ext/module.rb", "lib/version/ext/string.rb", "lib/version.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/version_spec.rb"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{simple version-number encapsulation}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
