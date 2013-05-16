module Glass
  class Engine < ::Rails::Engine
    config.glass = Glass
    binding.pry
  end
end