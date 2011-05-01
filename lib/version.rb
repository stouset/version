require 'version/ext/array'
require 'version/ext/module'
require 'version/ext/hash'
require 'version/ext/string'

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
    path = path ? Pathname.new(path) : self.version_file(caller.first)
    path = self.version_file(path) unless path.nil? or path.file?
    
    return nil unless path
    
    case path.extname
      when ''      then path.read.strip.to_version
      when '.yml'  then YAML::load(path.read).to_version
    end
  end
  
  #
  # Attempts to detect the version file for the passed +filename+. Looks up
  # the directory hierarchy for a file named VERSION or VERSION.yml. Returns
  # a Pathname for the file if found, otherwise nil.
  #
  def self.version_file(filename)
    Pathname(filename).dirname.expand_path.ascend do |d|
      break d.join('VERSION')     if d.join('VERSION').file?
      break d.join('VERSION.yml') if d.join('VERSION.yml').file?
    end
  end
  
  #
  # Creates a new version number, with a +major+ version number, +minor+
  # revision number, +revision+ number, and optionally more (unnamed)
  # version components.
  #
  def initialize(major, minor = 0, revision = nil, *rest)
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
    define_method(:"#{component}")  {    self[i]     }
    define_method(:"#{component}=") {|v| self[i] = v }
  end
  
  #
  # Retrieves the component of the Version at +index+.
  #
  def [](index)
    self.components[index] ? self.components[index].to_s : nil
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
  # Bumps the version number. Pass +component+ to bump a component other than the
  # least-significant part. Set +pre+ to :pre if you want to bump the component
  # to a prerelease version. Set +trim+ to true if you want the version to be
  # resized to only large enough to contain the component set.
  #
  #    "1.0.4a".bump!                     # => '1.0.4'
  #    "1.0.4a".bump!(:pre)               # => '1.0.4b'
  #    "1.0.4a".bump!(:minor, nil, true)  # => '1.1'
  #
  def bump!(component = nil, pre = nil, trim = false)
    if pre.nil?
      case component
        when nil        then self.version_bump(self.length - 1, trim)
        when :major     then self.version_bump(0, trim)
        when :minor     then self.version_bump(1, trim)
        when :revision  then self.version_bump(2, trim)
        when :pre       then self.bump!(nil, component, trim)
      end
    else
      if self.prerelease?
        case component
          when nil        then self.prerelease_bump(-1)
          when :major     then self.prerelease_bump(0)
          when :minor     then self.prerelease_bump(1)
          when :revision  then self.prerelease_bump(2)
        end
      else
        if component.nil?
          self.version_bump(0, trim)
        else
          self.bump!(component, nil, trim)
        end      
         
        self[-1] = self.components[-1].dup.prerelease
      end
    end
    
    self
  end
  
  #
  # Returns the current length of the version number.
  #
  def length
    self.components.length
  end
  
  #
  # Compares a Version against any +other+ object that responds to
  # +to_version+.
  #
  def <=>(other)
    self.components <=> other.to_version.components
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
  # Returns +self+.
  #
  def to_version
    self
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
  
  def components
    @components ||= []
  end
  
  def components=(components)
    components.each_with_index {|c, i| self[i] = c }
  end
  
  def version_bump(index = self.length - 1, trim = false)
    self.components.dup.delete_if { |e| e == self.components[index]}.each {|c| c.unprerelease }
    self.resize!(index + 1) if (trim or index >= self.length)
    self[index] = (self.components[index] || Component.new('0')).next
  end
  
  def prerelease_bump(index)
    if self.components[index] and self.components[index].prerelease?
      self[index] = self.components[index].next!(true)
    end
  end
end

class Version
  is_versioned
end
