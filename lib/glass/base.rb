require 'active_record'
module Glass
  class Base < ::ActiveRecord::Base
    self.abstract_class = true
    def self.handles_action(*args)
      puts args
    end
  end
end