require "active_support/dependencies"

module Glass
  class Engine < Rails::Engine
    isolate_namespace Glass
  end
end
require "glass/rails/engine"