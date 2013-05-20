class Glass::<%= model_name.camelize %> < Glass::TimelineItem

  has_menu_item :custom_action_name, display_name: "this is displayed", 
                                     icon_url: "http://icons.iconarchive.com/icons/enhancedlabs/lha-objects/128/Filetype-URL-icon.png", 
                                     with: :custom_action_handler
                                     
  def custom_action_handler
    ## logic for handling custom action
  end
end