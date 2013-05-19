class Glass::<%= model_name.camelize %> < Glass::TimelineItem

  has_menu_item :custom_action_name, with: :custom_action_handler

  def custom_action_handler
    ## logic for handling custom action
  end
end