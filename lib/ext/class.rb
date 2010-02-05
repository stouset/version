require 'pathname'

class Class
  #
  # Automagically sets a VERSION constant in the current class, populated by
  # the Version in +filename+. Attempts to guess the filename if none given.
  # Can read both .yml files and plain text.
  #
  def Version(filename = nil)
    # attempt to guess the filename if none given
    if filename.nil?
      filename = Pathname.new('.').expand_path.ascend do |d|
        break d.join('VERSION')     if d.join('VERSION').exist?
        break d.join('VERSION.yml') if d.join('VERSION.yml').exist?
      end
    end
    
    raise 'no VERSION or VERSION.yml found' unless filename
    
    path     = Pathname.new(filename)
    contents = path.read
    
    const_set :VERSION, case path.extname
      when ''      then contents.strip.to_version
      when '.yml'  then YAML::load(contents).to_version
    end
  end
end