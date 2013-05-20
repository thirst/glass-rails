require 'active_record'
require "glass/menu_item"
## this is an abstract class, not intended to be
## used directly

module Glass
  class TimelineItem < ::ActiveRecord::Base
    self.table_name = :glass_timeline_items

    belongs_to :google_account

    attr_accessible :display_time,      :glass_content,     :glass_content_type, 
                    :glass_created_at,  :glass_etag,        :glass_item_id, 
                    :glass_kind,        :glass_self_link,   :glass_updated_at, 
                    :is_deleted,        :google_account_id

    class_attribute :actions
    class_attribute :menu_items
    class_attribute :default_template 
    def self.defaults_template(opts={})
      self.defaults_template = opts[:with] if opts[:with]
    end
    def self.manages_templates(opts={})
      self.template_manager = opts[:with] if opts[:with]
    end

    def self.has_menu_item(action_sym, opts) 
      self.actions ||= []
      self.menu_items ||= []
      unless self.actions.include?(action_sym)
        self.actions += [action_sym] 
        menu_item = ::Glass::MenuItem.create(action_sym, opts)
        self.menu_items += [menu_item]
      end
    end
    def self.menu_items_hash
      {menuItems: self.menu_items.map(&:serialize) }
    end
    def serialize

    end
    def template
      self.class.default_template
    end
    def template_variables(variables={})
    end
    def has_default_template?
      self.class.default_template
    end
  end
end