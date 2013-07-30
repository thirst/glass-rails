class CreateGlassTimelineItems < ActiveRecord::Migration
  def change
    create_table :glass_timeline_items do |t|
      t.string :type
      t.references :google_account
      t.string :glass_item_id
      t.boolean :is_deleted
      t.string :glass_etag
      t.string :glass_self_link
      t.string :glass_kind
      t.datetime :glass_created_at
      t.datetime :glass_updated_at
      t.string :glass_content_type
      t.text :glass_content
      t.datetime :display_time
      t.integer :parent_id

      t.timestamps
    end
    add_index :glass_timeline_items, :google_account_id
  end
end
