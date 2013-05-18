require 'active_record'
module Glass
  class TimelineItem < ::ActiveRecord::Base

    self.table_name = :glass_timeline_items

    belongs_to :google_account
    attr_accessible :display_time,      :glass_content,     :glass_content_type, 
                    :glass_created_at,  :glass_etag,        :glass_item_id, 
                    :glass_kind,        :glass_self_link,   :glass_updated_at, 
                    :is_deleted
    def self.handles_action(*args)
      puts args
    end
  end
end