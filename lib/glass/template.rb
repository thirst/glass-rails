require "rails/all"
require 'action_view'
module Glass
  class Template < ActionView::Base
    # include ::Rails.application.routes.url_helpers
    # include ::ActionView::Helpers::TagHelper
    attr_accessor :timeline_item, :template_name
    def initialize(opts={})
      self.template_name = opts.delete(:template_name) || "simple_html.html.erb"
      set_template_instance_variables(opts)
      if glass_template_path.present? 
        super(Rails.root.join(glass_template_path))
      else
        super(Rails.root.join("app", "views", "glass-templates"))
      end
    end
    private
    def set_template_instance_variables(opts)
      opts.each {|k,v| self.instance_variable_set("@#{k}", v) }
    end
    def glass_template_path
      ::Glass.glass_template_path
    end
  end  
end