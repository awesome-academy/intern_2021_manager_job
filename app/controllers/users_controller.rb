class UsersController < ApplicationController
  before_action :check_role_user, only: %i(new create)

  def new
    @user = current_account.build_user
  end

  def create
    @user = current_account.build_user user_params
    return render :new unless @user.save

    flash[:success] = t "controller.provide_info_success"
    redirect_to root_path
  end

  private
  def check_role_user
    return if current_account.user?

    flash[:warning] = t "controller.no_permission"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end
end
