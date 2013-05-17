require "rails/all"
require 'action_view'
module Glass
  class Template < ActionView::Base
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::TagHelper
    attr_accessor :timeline_item, :template, :extension
    
    def default_url_options
      {host: 'yourhost.org'}
    end
  end  
end