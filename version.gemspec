# -*- encoding: utf-8 -*-
# stub: version 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "version".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Stephen Touset".freeze]
  s.date = "2017-04-22"
  s.email = "stephen@touset.org".freeze
  s.extra_rdoc_files = ["History.rdoc".freeze, "README.rdoc".freeze, "TODO.rdoc".freeze]
  s.files = ["Gemfile".freeze, "Gemfile.lock".freeze, "History.rdoc".freeze, "License.txt".freeze, "README.rdoc".freeze, "Rakefile".freeze, "TODO.rdoc".freeze, "VERSION".freeze, "lib/rake/version_task.rb".freeze, "lib/version.rb".freeze, "lib/version/component.rb".freeze, "lib/version/ext/array.rb".freeze, "lib/version/ext/hash.rb".freeze, "lib/version/ext/module.rb".freeze, "lib/version/ext/string.rb".freeze, "spec/spec.opts".freeze, "spec/spec_helper.rb".freeze, "spec/version_spec.rb".freeze]
  s.homepage = "https://github.com/stouset/version".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "2.6.10".freeze
  s.summary = "simple version-number encapsulation".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_development_dependency(%q<rspec-its>.freeze, ["~> 1"])
    else
      s.add_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_dependency(%q<rspec-its>.freeze, ["~> 1"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["~> 12"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3"])
    s.add_dependency(%q<rspec-its>.freeze, ["~> 1"])
  end
end
