class CreateGlassAccounts < ActiveRecord::Migration
  def change
    create_table :glass_accounts do |t|
      t.string :token
      t.string :refresh_token
      t.integer :expires_at
      t.string :email
      t.string :name
      t.references :<%=user_model.underscore.singularize%>, index: true
    end
  end
end