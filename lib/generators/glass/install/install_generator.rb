require 'generators/glass'
require 'rails/generators'
require 'rails/generators/migration'

module Glass
  module Generators
    class InstallGenerator < Base
      def create_configuration_file
        copy_file("google-oauth.yml", "config/google-api-keys.yml")
      end
    end
  end
end