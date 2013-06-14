class Glass::<%= model_name.camelize %> < Glass::TimelineItem


  defaults_template with: "table.html.erb"



  ## this feature is experimental and not yet ready
  ## for use:
  # manages_template with: :template_manager


  #### these are your menu items which you define 
  #### for the timeline object.
  #### 

  has_menu_item :custom_action_name, display_name: "this is displayed", 
                                     icon_url: "http://icons.iconarchive.com/icons/enhancedlabs/lha-objects/128/Filetype-URL-icon.png", 
                                     handles_with: :custom_action_handler




  def custom_action_handler(response)
    ## logic for handling custom action
    ##
    ## response is a hash object which google sends back 
    ## when the action is invoked
  end

end