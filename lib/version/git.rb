module Version
  
  class Git
    
    attr_reader :repository
    
    def self.git_path 
      @git_path ||= (result = `which git`.chomp) && $?.success? && Pathname.new(result).expand_path
    end
    
    def initialize(path)
      @repository = Pathname.new(File.expand_path('.git', path)).expand_path
    end

    def repository?
      File.exist? @repository
    end

    def head
      @head ||= git_command('rev-parse', '--verify', 'HEAD')
    end
    
    def branch
      @branch ||= git_command('name-rev', 'HEAD').gsub('HEAD ', '')
    end
    
    def to_s
      self.inspect
    end
      
    def inspect
      %[#<#{self.class.name} branch: "#{branch}", head: "#{head}>"]
    end
    
    private
    
    def git_command(cmd, *args)
      args = args.flatten.compact.map {|a| a.to_s }

      IO.popen([self.class.git_path.to_s, cmd, *args]) { |io| io.read }.strip
    end
    
  end
  
end