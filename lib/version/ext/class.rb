require 'version'

class Class
  #
  # Automagically sets a VERSION constant in the current class according to
  # the results of Version.current.
  #
  def is_versioned
    const_set :VERSION, Version.current(File.dirname(caller.first))
  end
end
