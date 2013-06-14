require 'generators/glass'
require 'rails/generators'
require 'rails/generators/migration'

module Glass
  module Generators
    class ModelGenerator < ::Rails::Generators::Base
      argument :model_name, type: :string

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end
      
      def copy_glass_templates
        unless File.directory?("app/models/glass/")
          empty_directory("app/models/glass")
        end
      end
      def create_glass_model
        template("model.rb", "app/models/glass/#{model_name.underscore}.rb")
      end
    end
  end
end