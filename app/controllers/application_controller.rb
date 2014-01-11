class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :require_login


  private
  def flash_alert(obj, msg)
    err_str = view_context.render_for_controller("validation_errors", {:obj => obj})
  	msg += (" for the following " + view_context.pluralize(obj.errors.full_messages.length, "reason") + ":#{err_str}") unless obj.errors.messages.size < 1
  	flash.now.alert = msg.html_safe
  end
end
