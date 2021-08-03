class ApplicationController < ActionController::Base
  before_action :set_locale

  include SessionsHelper

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include? locale
    I18n.locale = check ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def log_in_require
    return if logged_in?

    store_location
    redirect_to login_path
  end

  def find_job
    @job = Job.find_by id: params[:job_id]
    return if @job

    flash[:danger] = t "controller.job_not_found"
    redirect_to root_path
  end
end
