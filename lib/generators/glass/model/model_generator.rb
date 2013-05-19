require 'generators/glass'
require 'rails/generators'
require 'rails/generators/migration'

module Glass
  module Generators
    class ModelGenerator < Base
      argument :model_name, type: :string
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