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

  # when true, commits version bumps automatically (default: autodetect)
  attr_accessor :with_hg

  # when true, tags version bumps automatically (default: false)
  attr_accessor :with_hg_tag

  # when true, commits version bumps automatically (default: autodetect)
  attr_accessor :with_svn

  # when true, tags version bumps automatically if the current svn URL
  # either ends in '<base>/trunk' or '<base>/branches/<branch>' by
  # copying the current svn URL to the '<base>/tags/<version>'
  # (default: false)
  attr_accessor :with_svn_tag
  
  # when set with a Gem::Specification, automatically emits an updated
  # gemspec on version bumps
  attr_accessor :with_gemspec
  
  #
  # Creates a new VersionTask with the given +filename+. Attempts to
  # autodetect the +filetype+ and whether or not git or hg is present.
  #
  def initialize(filename = 'VERSION')
    self.filename = filename
    
    yield(self) if block_given?
    
    self.with_git = self.with_git && File.exist?('.git')
    self.with_hg = self.with_hg && File.exist?('.hg')
    self.with_svn = self.with_svn && File.exist?('.svn')

    fail 'Filename required' if self.filename.nil?
    
    file filename
    
    desc "Print the current version number (#{read})"
    task :version => filename do
      puts read
    end
    
    namespace :version do

      #add to this task to perform some operation post-bump
      @sync = task :sync

      desc "Bump to #{read.bump!}"
      task :bump => filename do |t|
        puts write(read.bump!)
        @sync.execute()
      end
      
      namespace :bump do

        desc "Bump to #{read.bump!(:major)}"
        task :major => filename do
          puts write(read.bump!(:major))
          @sync.execute()
        end
        
        desc "Bump to #{read.bump!(:minor)}"
        task :minor => filename do
          puts write(read.bump!(:minor))
          @sync.execute()
        end
        
        desc "Bump to #{read.bump!(:revision)}"
        task :revision => filename do
          puts write(read.bump!(:revision))
          @sync.execute()
        end
        
        desc "Bump to #{read.bump!(:pre)}"
        task :pre => filename do
          puts write(read.bump!(:pre))
          @sync.execute()
        end
        
        namespace :pre do
          
          desc "Bump to #{read.bump!(:major, true)}"
          task :major => filename do
            puts write(read.bump!(:major, true))
            @sync.execute()
          end
          
          desc "Bump to #{read.bump!(:minor, true)}"
          task :minor => filename do |t|
            puts write(read.bump!(:minor, true))
            @sync.execute()
          end
          
          desc "Bump to #{read.bump!(:revision, true)}"
          task :revision => filename do
            puts write(read.bump!(:revision, true))
            @sync.execute()
          end

        end#namespace :pre do
      end#namespace :bump do

      desc 'Creates a version file with an optional VERSION parameter'
      task :create do
        version = Version.to_version(ENV['VERSION'] || '0.0.0')
        puts write(version)
      end

    end#namespace :version do

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
  
  private
  
  #
  # Returns the Version contained in the file at +filename+.
  #
  def read
    contents = path.read rescue '0.0.0'
    
    case filetype.to_s
      when ''    then Version.to_version(contents.chomp)
      when 'yml' then Version.to_version(YAML::load(contents))
    end
  end
  
  #
  # Writes out +version+ to the file at +filename+ with the correct format.
  #
  def write(version)
    return if path.exist? && version == read
    
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

    if self.with_hg
      `hg add #{self.filename}` unless `hg status -u #{self.filename}`.empty?
      `hg add #{self.gemspec}` if (self.with_gemspec && !`hg status -u #{self.gemspec}`.empty?)
      `hg commit #{self.filename} #{self.with_gemspec ? self.gemspec : ''} -m "Version bump to #{version}"`
      `hg tag #{version}` if self.with_hg_tag
    end

    if self.with_svn
      `svn commit #{self.filename} #{self.with_gemspec ? self.gemspec : ''} -m "Version bump to #{version}"`

      # This only attempts to make 'standard' tags.  That is, if the
      # current svn URL ends in 'trunk' or 'branches/<branch>', then
      # it will be copied to 'tags/<version>'
      if self.with_svn_tag
        url = nil
        `svn info`.each_line do |line|
          if line =~ /^URL:\s+(.*)$/
            url = $1
            break
          end
        end

        if url && url =~ /^(.*)\/(trunk|branches\/[\w]+)$/
          base = $1
          tag_url = "#{base}/tags/#{version}"
          `svn copy #{url} #{tag_url} -m "Tag #{version}"`
        end
      end
    end
    
    version
  end
end
