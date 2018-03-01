module ApplicationHelper

  def page_classes
    classes = []
    classes << controller_name
    classes << action_name
    classes.join(' ').squish
  end
end
