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
                                     handled_by: :custom_action_handler




  def custom_action_handler
    ## logic for handling custom action
  end

end