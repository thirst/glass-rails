require "rails/all"
require 'action_view'
module Glass
  class Template < ActionView::Base
    # include ::Rails.application.routes.url_helpers
    # include ::ActionView::Helpers::TagHelper
    attr_accessor :timeline_item, :template_name
    def initialize(opts={})
      self.template_name = opts.delete(:template_name) || "simple.html.erb"
      set_template_instance_variables(opts)
      super(glass_template_path)
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