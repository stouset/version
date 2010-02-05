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
    
    desc 'Print the current version number'
    task(:version => filename) { puts read }
    
    namespace :version do
      desc 'Creates a version file with an optional VERSION parameter'
      task(:create ) do
        version = (ENV['VERSION'] || '0.0.0').to_version
        puts write(version)
      end
      
      desc 'Bump the least-significant version number'
      task(:bump => filename) { puts write(read.bump!) }
      
      namespace :bump do
        desc 'Bump the major version number'
        task(:major => filename) { puts write(read.bump!(0)) }
        
        desc 'Bump the minor version number'
        task(:minor => filename) { puts write(read.bump!(1)) }
        
        desc 'Bump the revision number'
        task(:revision => filename) { puts write(read.bump!(2)) }
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
    path.open('w') do |io|
      io << case filetype.to_s
        when ''    then version.to_s + "\n"
        when 'yml' then version.to_yaml
      end
    end
    
    if self.with_git
      `git add #{self.filename}`
      `git commit -m "Version bump to #{version}"`
      `git tag #{version}` if self.with_git_tag
    end
    
    version
  end
end
