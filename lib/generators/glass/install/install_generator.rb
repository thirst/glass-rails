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
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      def create_glass_account_migration
        generate("model", "google_account token refresh_token expires_at:integer email name id_token #{user_model.underscore.singularize}:references")
        remove_file("app/models/google_account.rb")
        template("google_account.rb", "app/models/google_account.rb")
        insert_into_file("app/models/#{user_model.underscore.singularize}.rb", "\n\s\shas_one :google_account\n\n", after: "ActiveRecord::Base\n")
      end
      def create_timeline_items_migration
        generate("model", "glass/timeline_item google_account:references "\
                             "glass_item_id is_deleted:boolean glass_etag "\
                             "glass_self_link glass_kind glass_created_at:datetime "\
                             "glass_updated_at:datetime glass_content_type "\
                             "glass_content:text display_time:datetime")
        gsub_file("app/models/glass/timeline_item.rb", "ActiveRecord", "Glass")
        insert_into_file("app/models/glass/timeline_item.rb", "\n\s\sself.table_name = :glass_timeline_item", after: "::Base\n")
      end
      def create_initializer
        copy_file "initializer.rb", "config/initializers/glass.rb"
      end
    end
  end
end