require "rails/all"
require 'action_view'
module Glass
  class Template < ActionView::Base
    attr_accessor :timeline_item, :template_name

    ## basically, any thing passed in the hash here gets instantiated as
    ## an instance variable in the view, except :template_name
    ##
    ## the [:template_name] key will be reserved for specifying the relative
    ## path (to the glass_template_path) to your template.

    ## For example,

    ## if your glass_template_path is set to:
    ## "app/views/glass-templates"

    ## and you have a file in a folder 
    ## "app/views/glass-templates/tweets/blue.html.erb"

    ## then your template name would be:
    ## "tweets/blue.html.erb"
    def initialize(opts={})
      self.template_name = opts.delete(:template_name) || "simple.html.erb"
      set_template_instance_variables(opts)
      super(glass_template_path)
    end
    private

    ##
    ## substantiate the instance variables needed by action view for rendering
    ## in the erb templates.
    ## 
    def set_template_instance_variables(opts)
      opts.each {|k,v| self.instance_variable_set("@#{k}", v) }
    end
    ## just for convenience.
    def glass_template_path
      ::Glass.glass_template_path
    end
  end  
end