class Admin::UsersController < AdminController

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
    @inviter = @user.invited_by_id.present? ? User.find(@user.invited_by_id) : nil
  end

  def edit
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy!

    flash[:notice] = t('user.flashes.destroy.notice', identifier: "#{@user.full_name} <#{@user.email}>")
    redirect_to admin_users_path
  end
end