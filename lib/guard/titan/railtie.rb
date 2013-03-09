module Guard::TitanRailtie
  class Railtie < Rails::Railtie
    rake_tasks do
      load "titan.tasks"
    end
  end
end
