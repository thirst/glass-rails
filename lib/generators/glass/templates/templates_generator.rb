require 'generators/glass'
require 'rails/generators'
require 'rails/generators/migration'

module Glass
  module Generators
    class TemplatesGenerator < Base
      include Rails::Generators::Migration

      def copy_glass_templates
        glass_templates_path = ::Glass.glass_templates_path
        directory("templates", glass_templates_path)
      end
    end
    private

  end
end