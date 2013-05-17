require 'generators/glass'
require 'rails/generators'
require 'rails/generators/migration'

module Glass
  module Generators
    class TemplatesGenerator < Base
      include Rails::Generators::Migration

      def copy_glass_templates
        directory("", "app/views/glass-templates")
      end
    end
    private
  end
end