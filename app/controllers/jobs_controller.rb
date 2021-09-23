class JobsController < ApplicationController
  before_action :authenticate_account!, :load_company, except: %i(index show)
  before_action :load_job, except: %i(index new create)
  authorize_resource

  def index
    @search = Job.ransack search_params
    @jobs = @search.result.categories_cont_all(params[:categories])
                   .includes(:company).page(params[:page])
                   .per Settings.jobs.max_items_per_page
  end

  def new
    @job = @company.jobs.build
    @job.reason_to_joins.new
    @categories = Category.all
  end

  def create
    @job = @company.jobs.build job_params
    if @job.save
      flash[:success] = t "jobs.create.success"
      redirect_to @job
    else
      flash[:danger] = t "jobs.create.failure"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @job.update job_params
      flash[:success] = t "jobs.update.success"
      redirect_to @job
    else
      flash[:danger] = t "jobs.update.failure"
      render :edit
    end
  end

  def destroy
    if @job.destroy
      flash[:success] = t "jobs.destroy.success"
    else
      flash[:danger] = t "jobs.destroy.failure"
    end
    redirect_to @company
  end

  private

  def load_company
    if current_account.company?
      @company = current_account.company
      return if @company

      redirect_to new_company_path
    else
      redirect_to root_path
    end
  end

  def load_job
    @job = Job.find_by id: params[:id]
    return if @job

    flash[:danger] = t "controller.job_not_found"
    redirect_to root_path
  end

  def job_params
    params.require(:job).permit Job::JOB_PARAMS
  end

  def search_params
    return params[:search] if params.key? :search

    params[:company_id_in] = params[:companies].keys if params.key? :companies
    params[:categories] = params[:categories].keys if params.key? :categories
    get_salary
    params.permit [:name_cont, :salary_lteq, :salary_gteq, company_id_in: []]
  end

  def get_salary
    return if params[:salary_id].blank?

    salary = Salary.find_by id: params[:salary_id]
    return unless salary

    params[:salary_lteq] = salary.max_salary
    params[:salary_gteq] = salary.min_salary
  end
end
