require 'pathname'

#
# Encodes version-numbering logic into a convenient class.
#
class Version
  include Comparable
  
  autoload :Component, 'version/component'
  
  #
  # Searches through the parent directories of the calling method and looks
  # for a VERSION or VERSION.yml file to parse out the current version. Pass
  #
  # Pass a filename to +path+ to override autodetection, or pass a directory
  # name as +path+ to autodetect within a given directory
  #
  def self.current(path = nil)
    # if path is nil, detect automatically; if path is a directory, detect
    # automatically in the directory; if path is a filename, use it directly
    path = path ? Pathname.new(path) : self.version_file(Pathname(caller.first).dirname)
    path = self.version_file(path) unless path.nil? or path.file?
    
    return nil unless path
    
    Version.new path.extname == '.yml' ? YAML::load(path.read) : path.read.strip
  end
  
  #
  # Attempts to detect the version file for the passed +filename+. Looks up
  # the directory hierarchy for a file named VERSION or VERSION.yml. Returns
  # a Pathname for the file if found, otherwise nil.
  #
  def self.version_file(path)
    Pathname(path).expand_path.ascend do |d|
      break d.join('VERSION')     if d.join('VERSION').file?
      break d.join('VERSION.yml') if d.join('VERSION.yml').file?
    end
  end
  
  def self.set(target, dir = nil)
    raise ArgumentError, 'Version can only be set on a module or class.' unless target.is_a?(Module)
    target.const_set :VERSION, Version.current(dir || File.dirname(caller.first))
  end

  #
  # Creates a new version number, with a +major+ version number, +minor+
  # revision number, +revision+ number, and optionally more (unnamed)
  # version components.
  #
  def initialize(object)
    major, minor, revision, *rest = *case object
    when Array    then object
    when Hash     then object.values_at(:major, :minor, :revision, :rest)
    when String   then object.split(%r{\.})
    when Numeric  then object.to_s.split(%r{\.})
    else nil
    end
    self.components = [ major, minor, revision, *rest ]
  end
  
  #
  # For +major+, +minor+, and +revision+, make a helper method that gets and
  # sets each based on accessing indexes.
  #--
  # TODO: make these rdoc-capable
  #++
  #
  [ :major, :minor, :revision ].to_enum.each.with_index do |component, i|
    define_method(component)  { self.components[i] ? self.components[i].to_s : nil }
    define_method("#{component}=") {|v| self[i] = v  }
  end
  
  #
  # Set the component of the Version at +index+ to +value+. Zeroes out any
  # trailing components.
  #
  # If +index+ is greater than the length of the version number, pads the
  # version number with zeroes until +index+.
  #
  def []=(index, value)
    return self.resize!(index)               if value.nil? || value.to_s.empty?
    return self[self.length + index] = value if index < 0
    
    length = self.length - index
    zeroes = Array.new length.abs, Version::Component.new('0')
    value  = Version::Component.new(value.to_s)
    
    if length >= 0
      self.components[index, length] = zeroes
      self.components[index]         = value
    else
      self.components += zeroes
      self.components << value
    end
  end
  
  def prerelease?
    self.components.any? {|c| c.prerelease? }
  end
  
  #
  # Resizes the Version to +length+, removing any trailing components. Is a
  # no-op if +length+ is greater than its current length.
  #
  def resize!(length)
    self.components = self.components.take(length)
    self
  end
  
  #
  # Bumps the version number. Pass +component+ to bump a component other than
  # the least-significant part. Set +pre+ to true if you want to bump the
  # component to a prerelease version. Set +trim+ to true if you want the
  # version to be resized to only large enough to contain the component set.
  #
  #    "1.0.4a".bump!                       # => '1.0.4'
  #    "1.0.4a".bump!(:pre)                 # => '1.0.4b'
  #    "1.0.4a".bump!(:minor, false, true)  # => '1.1'
  #    "1.0.4a".bump!(:minor, true, true)   # => '1.1a
  #    "1.0.4a".bump!(:minor, true, false)  # => '1.1.0a'
  #
  def bump!(component = -1, pre = false, trim = false)
    case component
      when :major    then self.bump!(0,  pre,  trim)
      when :minor    then self.bump!(1,  pre,  trim)
      when :revision then self.bump!(2,  pre,  trim)
      when :pre      then self.bump!(-1, true, trim)
      else
        # resize to match the new length, if applicable
        self.resize!(component + 1) if (trim or component >= self.length)
        
        # mark all but the changed bit as non-prerelease
        self[0...component].each(&:unprerelease!)
        
        # I don't even understand this part any more; god help you
        self[component] = self[component].next if     pre and self.prerelease? and component == self.length - 1
        self[component] = self[component].next unless pre and self.prerelease? and component == -1
        self[-1]        = self[-1].next(true)  if pre
        self
    end
  end
    
  #
  # Returns the current length of the version number.
  #
  def length
    self.components.length
  end
  
  #
  # Compares a Version against any +other+ object that looks like a version
  def <=>(other)
    self.components <=> Version.new(other).components
  end
  
  #
  # Converts the version number into an array of its components.
  #
  def to_a
    self.components.map {|c| c.to_s }
  end
  
  #
  # Converts the version number into a hash of its components.
  #
  def to_hash
    { :major    => self.major,
      :minor    => self.minor,
      :revision => self.revision,
      :rest     => self.length > 3 ? self.to_a.drop(3) : nil }.
      delete_if {|k,v| v.nil? }
  end
  
  #
  # The canonical representation of a version number.
  #
  def to_s
    self.to_a.join('.')
  end
  
  #
  # Returns a YAML representation of the version number.
  #
  def to_yaml
    YAML::dump(self.to_hash)
  end
  
  #
  # Returns a human-friendly version format.
  #
  def inspect
    self.to_s.inspect
  end
  
  protected
  
  #
  # Retrieves the component of the Version at +index+.
  #
  def [](index)
    self.components[index] || Component.new('0')
  end
  
  def components
    @components ||= []
  end
  
  def components=(components)
    components.each_with_index {|c, i| self[i] = c }
  end
  
  # Set VERSION on Version!
  set(self)
  
end

require 'version/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3


