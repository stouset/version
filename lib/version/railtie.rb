require 'rake/version_task'
require 'rails'

class Version
  class Railtie < Rails::Railtie

    Rake::VersionTask.new
    Version.set Rails.application.class.parent

  end
  
end