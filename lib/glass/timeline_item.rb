require 'active_record'
require "glass/menu_item"
## this is an abstract class, not intended to be
## used directly

module Glass
  class TimelineItem < ::ActiveRecord::Base
    class GoogleAccountNotSpecifiedError < StandardError;end;
    class UnserializedTemplateError < StandardError; end;
    self.table_name = :glass_timeline_items

    belongs_to :google_account

    attr_accessible :display_time,      :glass_content,     :glass_content_type, 
                    :glass_created_at,  :glass_etag,        :glass_item_id, 
                    :glass_kind,        :glass_self_link,   :glass_updated_at, 
                    :is_deleted,        :google_account_id

    class_attribute :actions
    class_attribute :menu_items
    class_attribute :default_template 

    attr_accessor :template_type
    attr_writer :client, :mirror_content


    ### a couple custom attr_readers which raise a
    ### helpful error message if the value is nil;
    ### i.e. error flow handling.
    def mirror_content
      raise UnserializedTemplateError unless @mirror_content
      @mirror_content
    end 
    def client
      raise UnserializedTemplateError unless @client
      @client
    end


    ## this methods sets the default template for
    ## all instances of the class. 

    ## Usage: 
    ##   class Glass::Tweet < Glass::TimelineItem

    ##     defaults_template "table.html.erb" 
                ## this defaults to the glass_template_path
                ## which you set in your glass initializer.

    ##   end
    def self.defaults_template(opts={})
      self.defaults_template = opts[:with] if opts[:with]
    end
    ## this methods sets the default template for
    ## all instances of the class. 

    ## Usage: 
    ##   class Glass::Tweet < Glass::TimelineItem

    ##     manages_templates :template_manager_name
                ## this will set your template manager
                ## for this class. this will override
                ## defaults_template path if it is 
                ## defined.

    ##   end
    def self.manages_templates(opts={})
      self.template_manager = opts[:with] if opts[:with]
    end
    ## this methods sets the default template for
    ## all instances of the class. 

    ## Usage: 
    ##   class Glass::Tweet < Glass::TimelineItem

    ##     has_menu_item :my_custom_action,
    ##       display_name: "Displayed Name",
    ##       icon_url: "url for icon",
    ##       handles_with: :custom_handler_methodname

    ##       def custom_handler_methodname
    ##         # this gets executed when this
    ##         # action occurs.
    ##       end
    ##   end
    def self.has_menu_item(action_sym, opts) 
      self.actions ||= []
      self.menu_items ||= []
      unless self.actions.include?(action_sym)
        self.actions += [action_sym] 
        defines_callback_methods
        menu_item = ::Glass::MenuItem.create(action_sym, opts)
        self.menu_items += [menu_item]
      end
    end
    def self.defines_callback_methods(action, opts)
      self.class.send(:define_method, "handles_#{action.underscore}") do
        self.send(opts[:with])
      end
    end
    def self.menu_items_hash
      {menuItems: self.menu_items.map(&:serialize) }
    end
    def menu_items_hash
      self.class.menu_items_hash
    end
    def serialize(opts={})
      raise GoogleAccountNotSpecifiedError unless self.google_account.present?
      type = self.template_type || :html
      json_hash = {}
      json_hash[type] = self.setup_template(opts.delete(:template_variables))
      json_hash = json_hash.merge(self.menu_items_hash)
      json_hash.merge(opts)
      self.mirror_content = json_hash
      self.client = Glass::Client.create(self)
      return self
    end




    def template
      self.class.default_template || "simple.html.erb"
    end
    def setup_template(variables={})
      Glass::Template.new({template_name: self.template}.merge(variables)).render template: self.template
    end
    def has_default_template?
      self.class.default_template
    end
  end
end