class Admin::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_administrators!, except: [:edit, :update]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: additional_permitted_params)
    devise_parameter_sanitizer.permit(:accept_invitation, keys: additional_permitted_params)
  end

  def additional_permitted_params
    [
      :first_name,
      :last_name
    ]
  end

  def after_invite_path_for(resource)
    admin_users_path
  end

  def after_accept_path_for(resource)
    authenticated_root_path
  end

  def after_sign_in_path_for(resource)
    authenticated_root_path
  end
end