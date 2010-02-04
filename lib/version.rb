#
# Encodes version-numbering logic into a convenient class.
#
class Version
  include Comparable
  
  attr_accessor :major
  attr_accessor :minor
  attr_accessor :revision
  attr_accessor :rest
  
  #
  # Creates a new Version number, with a +major+ version number, +minor+
  # revision number, +revision+ number, and optionally more (unnamed)
  # version components.
  #
  def initialize(major, minor = 0, revision = nil, *rest)
    self.major    = major
    self.minor    = minor
    self.revision = revision
    self.rest     = rest
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
    [ self.major, self.minor, self.revision, *self.rest ].compact
  end
  
  #
  # Converts the version number into a hash of its components.
  #
  def to_hash
    { :major    => self.major,
      :minor    => self.minor,
      :revision => self.revision,
      :rest     => self.rest }
  end
  
  def to_s
    self.to_a.join('.')
  end
  
  #
  # Returns +self+.
  #
  def to_version
    self
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