module ApplicationHelper

  def page_classes
    classes = []
    classes << controller_name
    classes << action_name
    classes.join(' ').squish
  end

  def google_maps_api?
    controller_name == 'tracks' && action_name == 'show'
  end
end
