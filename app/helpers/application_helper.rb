module ApplicationHelper
  def display_alert?
    controller.controller_name == 'admins' && controller.action_name == 'new'
  end
end
