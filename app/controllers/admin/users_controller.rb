class Admin::UsersController < AdminController

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
    @inviter = @user.invited_by_id.present? ? User.find(@user.invited_by_id) : nil
  end
end