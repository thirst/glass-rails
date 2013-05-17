require "rails/all"
require 'action_view'
module Glass
  class Template < ActionView::Base
    # include ::Rails.application.routes.url_helpers
    # include ::ActionView::Helpers::TagHelper
    # attr_accessor :timeline_item, :template, :extension
    def initialize(opts={})
      opts.each do |k,v|
        self.instance_variable_set("@#{k}".to_sym, v)
      end
      if glass_template_path.present? 
        super(Rails.root.join(glass_template_path))
      else
        super(Rails.root.join("app", "views", "glass-templates"))
      end
    end

    private
    def glass_template_path
      ::Glass.glass_template_path
    end
  end  
end