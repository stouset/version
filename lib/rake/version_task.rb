require 'rake/tasklib'
require 'pathname'

class Rake::VersionTask < Rake::TaskLib
  attr_accessor :filename
  attr_writer   :filetype
  
  #
  # Creates a new VersionTask with the given +filename+. Attempts to
  # autodetect the +filetype+.
  #
  def initialize(filename = 'VERSION')
    self.filename = filename
    
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
    
    version
  end
end
