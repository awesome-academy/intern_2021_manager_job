class CompaniesController < ApplicationController
  before_action :check_role_company, only: %i(new create)

  def new
    @company = current_account.build_company
  end

  def create
    @company = current_account.build_company company_params
    return render :new unless @company.save

    flash[:success] = t "controller.provide_info_success"
    redirect_to root_path
  end

  private
  def check_role_company
    return if current_account.company?

    flash[:warning] = t "controller.no_permission"
    redirect_to root_path
  end

  def company_params
    params.require(:company).permit Company::COMPANY_PARAMS
  end
end
