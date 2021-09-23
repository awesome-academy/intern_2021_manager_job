class CompaniesController < ApplicationController
  before_action :load_company, except: %i(new create)
  authorize_resource

  def new
    @company = current_account.build_company
  end

  def create
    @company = current_account.build_company company_params
    return render :new unless @company.save

    flash[:success] = t "controller.provide_info_success"
    redirect_to root_path
  end

  def show
    @job = @company.jobs
    @search = @job.ransack params[:search]
    @search.sorts = Job::SORT_PARAMS if @search.sorts.empty?

    @jobs = @search.result.includes([:company]).newest.page(params[:page])
                   .per Settings.companies.page.max
  end

  def edit; end

  def update
    if @company.update company_update_params
      flash[:success] = t "controller.profile_updated"
      redirect_to @company
    else
      flash[:danger] = t "controller.profile_update_failed"
      render :edit
    end
  end

  private
  def company_params
    params.require(:company).permit Company::COMPANY_PARAMS
  end

  def company_update_params
    params.require(:company).permit Company::UPDATE_PARAMS
  end

  def load_company
    @company = Company.find_by id: params[:id]
    return if @company

    flash[:warning] = t "controller.company_not_found"
    redirect_to root_path
  end
end
