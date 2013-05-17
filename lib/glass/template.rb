require "rails/all"
require 'action_view'
module Glass
  class Template < ActionView::Base
    # include ::Rails.application.routes.url_helpers
    # include ::ActionView::Helpers::TagHelper
    # attr_accessor :timeline_item, :template, :extension
    def initialize(param, opts)
      if glass.glass_template_path.present? 
        super(Rails.root.join(glass.glass_template_path))
      else
        super(Rails.root.join("app", "views", "glass-templates"))
      end
    end
  end  
end