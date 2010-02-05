require 'version'

class Hash
  #
  # Converts the Hash into a version number.
  #
  def to_version
    Version.new *self.values_at(:major, :minor, :revision, :rest)
  end
end
