module ActiverecordFlow
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/activerecord_flow.rake'
    end
  end
end
