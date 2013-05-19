require 'generators/glass'
require 'rails/generators'
require 'rails/generators/migration'

module Glass
  module Generators
    class InstallGenerator < Base
      include Rails::Generators::Migration
      argument :user_model, type: :string, default: "User"

      def create_configuration_file
        copy_file("google-oauth.yml", "config/google-api-keys.yml")
      end

      def create_glass_account_migration
        generate("model", "google_account token refresh_token expires_at:integer email name id_token #{user_model.underscore.singularize}:references")
        remove_file("app/models/google_account.rb")
        template("google_account.rb", "app/models/google_account.rb")
        insert_into_file("app/models/#{user_model.underscore.singularize}.rb", "\n\s\shas_one :google_account\n\n", after: "ActiveRecord::Base\n")
      end
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      def create_timeline_items_migration
        migration_template "glass_timeline_item_migration.rb", "db/migrate/create_glass_timeline_items.rb"
      end
      def create_initializer
        copy_file "initializer.rb", "config/initializers/glass.rb"
      end
    end
  end
end