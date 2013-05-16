require 'rails/generators/base'

module Glass
  module Generators
    class Base < Rails::Generators::Base #:nodoc:
      def self.source_root
        @_glass_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'glass', generator_name, 'templates'))
      end

      def self.banner
        "rails generate glass:#{generator_name} #{self.arguments.map{ |a| a.usage }.join(' ')} [options]"
      end

      private

      def add_gem(name, options = {})
        gemfile_content = File.read(destination_path("Gemfile"))
        File.open(destination_path("Gemfile"), 'a') { |f| f.write("\n") } unless gemfile_content =~ /\n\Z/
        gem name, options unless gemfile_content.include? name
      end

      def print_usage
        self.class.help(Thor::Base.shell.new)
        exit
      end
    end
  end
end