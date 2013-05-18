require 'active_record'
module Glass
  class Base < ::ActiveRecord::Base
    def self.handles_action(*args)
      puts args
    end
  end
end