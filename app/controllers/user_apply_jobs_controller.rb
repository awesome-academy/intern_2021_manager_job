class UserApplyJobsController < ApplicationController
  before_action :log_in_require, :get_info_current_user, :find_job

  def new; end

  def create
    update_check_info
    @current_user.apply @job
    flash[:success] = t "controller.applied"
    redirect_to root_path
  end

  def update_check_info
    if @current_user.update user_params
      flash[:success] = t "controller.profile_updated"
    else
      flash[:danger] = t "controller.profile_update_failed"
      redirect_to root_path
    end
  end

  private
  def get_info_current_user
    @current_user = User.find_by account_id: session[:account_id]
    return root_path unless @current_user

    @info_current_user = UserInfo.find_by user_id: @current_user.id
  end

  def user_params
    params.require(:user)
          .permit(User::USER_PARAMS,
                  user_info_attributes: UserInfo::USER_INFO_PARAMS)
  end
end
