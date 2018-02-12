class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def after_sign_in_path_for(resource)
    user_dashboard_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def authenticate_administrators!
    render_404 unless current_user.administrator?
  end

  def render_404
    raise ActionController::RoutingError.new 'Not Found'
  end
end
