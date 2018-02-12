class Admin::Users::DuplicateInvitationsController < Admin::UsersController

  def create
    @user = User.find params[:user_id]
    @user.invite!(current_user)

    flash[:notice] = I18n.t("devise.invitations.resend_instructions.notice", email: @user.email)
    redirect_back(fallback_location: admin_users_path)

  rescue ActiveRecord::RecordNotFound
    flash[:alert_html_safe] = I18n.t("devise.invitations.resend_instructions.alert_html", path: new_user_invitation_path)
    redirect_back(fallback_location: admin_users_path)
  end

end