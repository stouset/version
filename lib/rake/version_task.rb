require 'version'

require 'rake/tasklib'
require 'pathname'

class Rake::VersionTask < Rake::TaskLib
  attr_accessor :filename
  attr_writer   :filetype
  
  # when true, commits version bumps automatically (default: autodetect)
  attr_accessor :with_git
  
  # when true, tags version bumps automatically (default: false)
  attr_accessor :with_git_tag
  
  # when set with a Gem::Specification, automatically emits an updated
  # gemspec on version bumps
  attr_accessor :with_gemspec
  
  #
  # Creates a new VersionTask with the given +filename+. Attempts to
  # autodetect the +filetype+ and whether or not git is present.
  #
  def initialize(filename = 'VERSION')
    self.filename = filename
    self.with_git = File.exist?('.git')
    
    yield(self) if block_given?
    
    self.define
  end
  
  #
  # The +filetype+ of the file to be generated. Is determined automatically
  # if not set.
  #
  def filetype
    @filetype || self.path.extname[1..-1]
  end
  
  def gemspec
    Pathname("#{with_gemspec.name}.gemspec") if with_gemspec
  end
  
  protected
  
  #
  # The path for the +filename+.
  #
  def path
    Pathname.new(self.filename)
  end
  
  #
  # Defines the rake tasks.
  #
  def define
    fail 'Filename required' if self.filename.nil?
    
    file filename
    
    desc "Print the current version number (#{current_version})"
    task(:version => filename) { puts read }
    
    namespace :version do
      desc 'Creates a version file with an optional VERSION parameter'
      task(:create) do
        version = (ENV['VERSION'] || '0.0.0').to_version
        puts write(version)
      end

      desc "Bump the least-significant version number to #{current_version{|v| v.bump!}}"
      task(:bump => filename) { puts write(read.bump!) }

      namespace :bump do
        desc "Bump to major version number #{current_version{|v| v.bump!(:major)}}"
        task(:major => filename) { puts write(read.bump!(:major)) }

        desc "Bump to minor version number #{current_version{|v| v.bump!(:minor)}}"
        task(:minor => filename) { puts write(read.bump!(:minor)) }

        desc "Bump to revision number #{current_version{|v| v.bump!(:revision)}}"
        task(:revision => filename) { puts write(read.bump!(:revision)) }

        desc "Bump to major prerelease version #{current_version{|v| v.bump!(:pre)}}"
        task(:pre => filename) { puts write(read.bump!(:pre)) }

        namespace :pre do
          desc "Bump to minor prerelease version #{current_version{|v| v.bump!(:minor, :pre)}}"
          task(:minor => filename) { puts write(read.bump!(:minor, :pre)) }

          desc "Bump to revision prerelease version #{current_version{|v| v.bump!(:revision, :pre)}}"
          task(:revision => filename) { puts write(read.bump!(:revision, :pre)) }
        end
      end
    end
  end
  
  private
  
  #
  # Returns the Version contained in the file at +filename+.
  #
  def read
    contents = path.read
    
    case filetype.to_s
      when ''    then contents.chomp.to_version
      when 'yml' then YAML::load(contents).to_version
    end
  end
  
  #
  # Writes out +version+ to the file at +filename+ with the correct format.
  #
  def write(version)
    if version != current_version
      path.open('w') do |io|
        io << case filetype.to_s
          when ''    then version.to_s + "\n"
          when 'yml' then version.to_yaml
        end
      end
    
      if self.with_gemspec
        with_gemspec.version = version
        gemspec.open('w') {|io| io << with_gemspec.to_ruby }
      end
    
      if self.with_git
        `git add #{self.filename}`
        `git add #{self.gemspec}` if self.with_gemspec
        `git commit -m "Version bump to #{version}"`
        `git tag #{version}` if self.with_git_tag
      end
    end
    
    version
  end
  
  def current_version
    begin
      if block_given?
        version = yield read
      else
        version = read
      end
    rescue
      version = 'n/a'
    end
  end
end
