require 'rake/version_task'
require 'rails'

class Version
  class Railtie < Rails::Railtie

    Rake::VersionTask.new
    
    initializer 'version.add_to_application' do |app|
      Version.set app.class.parent, Rails.root
    end

  end
  
end