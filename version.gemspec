Gem::Specification.new do |s|
    s.name    = 'version'
    s.version = '1.1.0'
    s.summary = 'simple version-number encapsulation'

    s.author   = 'Stephen Touset'
    s.email    = 'stephen@touset.org'
    s.homepage = 'https://github.com/stouset/version'

    s.licenses = ['MIT']

    s.files = Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*']

    s.extra_rdoc_files = Dir['*.rdoc']
    s.rdoc_options = %w{ --main README.rdoc }

    s.add_development_dependency 'rake',      '~> 12'
    s.add_development_dependency 'rspec',     '~> 3'
    s.add_development_dependency 'rspec-its', '~> 1'
end
