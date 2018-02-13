class Admin::Users::DuplicateInvitationsController < Admin::UsersController

  def create
    @user = User.find params[:user_id]
    @user.invite!(current_user)

    flash[:notice] = t("user.flashes.resend_invite.notice", identifier: @user.email)
    redirect_back(fallback_location: admin_users_path)

  rescue ActiveRecord::RecordNotFound
    flash[:alert_html_safe] = t("user.flashes.resend_invite.alert_html", new_user_invitation_path: new_user_invitation_path)
    redirect_back(fallback_location: admin_users_path)
  end

end