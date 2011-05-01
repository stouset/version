require 'version'

class Version::Component
  attr_accessor :digits
  attr_accessor :letter
  
  #
  # Creates a single Component of a version, consisting of digits and
  # possibly a letter. For example, +1+, +3a+, +12+, or +0+.
  #
  def initialize(component)
    parts = component.split /(?=\D)/
    
    self.digits = parts[0].to_i
    self.letter = parts[1].to_s.strip
  end
  
  def initialize_copy(other)
    self.digits = other.digits
    self.letter = other.letter.dup
  end
  
  def prerelease?
    not self.letter.empty?
  end
  
  def prerelease
    if self.prerelease?
      self.next!(true)
    else
      self.letter = 'a'
      self
    end
  end
  
  def unprerelease
    if self.prerelease?
      self.next!
    end
  end
  
  def next(pre = false)
    self.dup.next!(pre)
  end
  
  def next!(pre = false)
    case
      when (    pre and     self.prerelease?) then self.letter.next!
      when (    pre and not self.prerelease?) then self.letter = 'a'; self.digits = self.digits.next
      when (not pre and     self.prerelease?) then self.letter = ''
      when (not pre and not self.prerelease?) then self.digits = self.digits.next
    end
    
    self
  end
  
  def <=>(other)
    self.to_sortable_a <=> other.to_sortable_a
  end
  
  def to_sortable_a
    [ self.digits, self.prerelease? ? 0 : 1, self.letter ]
  end
  
  def to_a
    [ self.digits, self.letter ]
  end
  
  def to_i
    self.digits
  end
  
  def to_s
    self.to_a.join
  end
  
  def inspect
    self.to_s.inspect
  end
end
