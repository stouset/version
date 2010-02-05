require 'version'

class String
  #
  # Converts the String into a version number.
  #
  def to_version
    Version.new *self.split(%r{\.})
  end
end
