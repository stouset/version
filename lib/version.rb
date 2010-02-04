#
# Encodes version-numbering logic into a convenient class.
#
class Version
  include Comparable
  
  #
  # Creates a new Version number, with a +major+ version number, +minor+
  # revision number, +revision+ number, and optionally more (unnamed)
  # version components.
  #
  def initialize(major, minor = 0, revision = nil, *rest)
    self.components = [ major, minor, revision, *rest ].compact
  end
  
  [ :major, :minor, :revision ].each.with_index do |component, index|
    define_method(:"#{component}")  {    self[index]          }
    define_method(:"#{component}=") {|v| self[index] = v.to_s }
  end
  
  def [](index)
    self.components[index]
  end
  
  def []=(index, value)
    if index < self.length
      length = self.length - index
      zeroes = Array.new(length - 1, 0)
      
      self.components[index, length] = [ value, *zeroes ]
    else
      length = (self.length - index).abs
      zeroes = Array.new(length, 0)
      
      self.components[index - length, length] = (zeroes << value)
    end
  end
  
  def bump(part = self.length)
    self.dup.bump!(part)
  end
  
  def bump!(part = self.length)
    before = self.to_a.take(part + 1)
    after  = self.to_a.drop(part + 1)
    
    before[-1] = before[-1].succ
    after      = Array.new(after.length, 0)
    
    from_a(before + after)
  def resize!(length)
    self.components = self.components[0, length]
    self
  end
  
    self
  end
  
  def length
    self.components.length
  end
  
  #
  # Compares a Version against any +other+ object that responds to
  # +to_version+.
  #
  def <=>(other)
    self.to_a <=> other.to_version.to_a
  end
  
  #
  # Converts the version number into an array of its components.
  #
  def to_a
    self.components
  end
  
  #
  # Converts the version number into a hash of its components.
  #
  def to_hash
    { :major    => self.major,
      :minor    => self.minor,
      :revision => self.revision,
      :rest     => self.length > 3 ? self.components.drop(3) : nil }
  end
  
  def to_s
    self.components.join('.')
  end
  
  #
  # Returns +self+.
  #
  def to_version
    self
  end
  
  alias inspect to_s
  
  protected
  
  attr_accessor :components
  
  private
  
  def from_a(array)
    self.major    = array.shift
    self.minor    = array.shift
    self.revision = array.shift
    self.rest     = array
  end
end

class Array
  #
  # Converts the Array into a Version number.
  #
  def to_version
    Version.new *self
  end
end

class Hash
  #
  # Converts the Hash into a Version number.
  #
  def to_version
    Version.new *self.values_at(:major, :minor, :revision, :rest)
  end
end

class String
  #
  # Converts the String into a Version number.
  #
  def to_version
    Version.new *self.split(%r{\.})
  end
end