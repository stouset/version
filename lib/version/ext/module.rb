require 'version'

class Module
  #
  # Automagically sets a VERSION constant in the current module according to
  # the results of Version.current.
  #
  def is_versioned
    const_set :VERSION, Version.current(File.dirname(caller.first))
  end
end
