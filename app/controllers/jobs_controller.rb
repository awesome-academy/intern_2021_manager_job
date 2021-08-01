class JobsController < ApplicationController
  before_action :log_in_require, :find_company, except: %i(index show)
  before_action :find_job_by_id, except: %i(index new create)
  before_action :correct_company, only: %i(edit update destroy)

  def index
    @jobs = Job.all
  end

  def new
    @job = @company.jobs.build
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
      flash[:failure] = t "jobs.destroy.failure"
    end
    redirect_to @company
  end

  private

  def find_company
    redirect_to root_path unless current_account.company?

    @company = current_account.company

    redirect_to new_company_path unless @company
  end

  def find_job_by_id
    @job = Job.find_by id: params[:id]
    return if @job

    flash[:danger] = t "jobs.not_found"
    redirect_to root_path
  end

  def correct_company
    redirect_to @job unless @job.company == current_account.company
  end

  def job_params
    params.require(:job).permit Job::JOB_PARAMS
  end
end
