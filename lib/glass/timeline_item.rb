require 'active_record'
require "glass/menu_item"
## this is an abstract class, not intended to be
## used directly

module Glass
  class TimelineItem < ::ActiveRecord::Base
    class GoogleAccountNotSpecifiedError < StandardError;end;
    class UnserializedTemplateError < StandardError; end;
    class MenuItemHandlerIsNotDefinedError < StandardError; end;
    class TimelineInsertionError < StandardError; end;

    self.table_name = :glass_timeline_items

    belongs_to :google_account

    attr_accessible :display_time,      :glass_content,     :glass_content_type, 
                    :glass_created_at,  :glass_etag,        :glass_item_id, 
                    :glass_kind,        :glass_self_link,   :glass_updated_at, 
                    :is_deleted,        :google_account_id



    ## i'd use cattr_accessor, but unfortunately
    ## ruby has some very crappy class variables, which
    ## are nonsensically over-written across sub-classes.
    ## so use the rails class_attribute helpers instead.

    class_attribute :actions
    class_attribute :menu_items
    class_attribute :default_template 

    attr_accessor :template_type, :to_json



    ## only a writer for these two
    ## because I want to hook an error 
    ## message to each of these if they haven't 
    ## had there values set yet.
    attr_writer :client, :mirror_content, :template_name








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
      self.default_template = opts[:with] if opts[:with]
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
    def self.has_menu_item(action_sym, opts={}) 
      self.actions ||= []
      self.menu_items ||= []
      unless self.actions.include?(action_sym)
        self.actions += [action_sym] 
        defines_callback_methods(action_sym, opts)
        menu_item = ::Glass::MenuItem.create(action_sym, opts)
        self.menu_items += [menu_item]
      end
    end



    ## this is really just a little meta-programming
    ## trick which basically forces a call to the method 
    ## specified by with parameter in the has_menu_item method.
    ## 
    ## it allows you to put the callback logic right 
    ## there in the model. 

    def self.defines_callback_methods(action, opts)
      self.send(:define_method, "handles_#{action.to_s.underscore}") do
        if self.respond_to?(opts[:handles_with])
          self.send(opts[:handles_with])
        else 
          raise MenuItemHandlerIsNotDefinedError
        end
      end
    end



    ## convert the menu items into hash form
    ## not a part of the public api.
    def self.menu_items_hash
      {menuItems: self.menu_items.map(&:serialize) }
    end

    ## convert class to instance method.
    ## not meant to be a part of the public api.
    def menu_items_hash
      self.class.menu_items_hash
    end





    ## this method will instantiate instance variables 
    ## in the erb template with the values you specify
    ## in a hash parameter under the key [:template_variables]

    ## For example,
    ## @google_account = GoogleAccount.first
    ## @timeline_object =  TimelineObject.new(google_account_id: @google_account.id)
    ## @timeline_object.serialize({template_variables: {content: "this is the content
    ##                                                            i've pushed to glass"}})
    ## 
    ## would render this erb template:


    ## <article> 
    ##   <%= @content %>
    ## </article>

    ## into this:
  
    ## '<article> \n    this is the content i've pushed to glass \n  </article>'
    ##
    ##
    ## an html serialization of your timeline object, which glass
    ## requests you send with your push.


    ## 
    def serialize(opts={})
      raise GoogleAccountNotSpecifiedError unless self.google_account.present?
      type = self.template_type || :html
      json_hash = {}
      json_hash[type] = self.setup_template(opts.delete(:template_variables).merge({template_name: opts.delete(:template_name) }))
      json_hash = json_hash.merge(self.menu_items_hash)
      json_hash.merge(opts)
      self.to_json = json_hash
      self.client = Glass::Client.create(self)
      return self
    end

    def insert(opts={})
      result = client.insert(opts)
      if result.error? 
        raise TimelineInsertionError
      else
        data = result.data
        result_data_type = :html #default
        [:html, :text].each do |result_type|
          result_data_type = result_type if data.send(result_type).present?
        end
        self.update_attributes(glass_item_id: data.id, 
                                glass_etag: data.etag,
                                glass_self_link: data.self_link,
                                glass_kind: data.kind,
                                glass_created_at: data.created,
                                glass_updated_at: data.updated,
                                glass_content_type: result_data_type,
                                glass_content: data.send(result_data_type))
      end
    end
    def patch(opts={})
      
    end
    # def update(opts={})

    # end



    ## this is not intended to be a part of the public api
    def template_name
      @template_name = self.class.default_template || "simple.html.erb"
    end

    ## this is not intended to be a part of the public api
    def setup_template(variables={})
      glass_template_path = variables[:template_name] || self.template_name
      Glass::Template.new({template_name: glass_template_path}.merge(variables)).render_self
    end

    ## this is not intended to be a part of the public api
    def has_default_template?
      self.class.default_template
    end
  end
end