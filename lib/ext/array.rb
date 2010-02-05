class Array
  #
  # Converts the Array into a version number.
  #
  def to_version
    Version.new *self
  end
end
