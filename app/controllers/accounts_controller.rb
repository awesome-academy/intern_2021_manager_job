class AccountsController < ApplicationController
  def new
    @account = Account.new
    @roles = [
      {value: "user", name: t("accounts.new.user")},
      {value: "company", name: t("accounts.new.company")}
    ]
  end

  def create
    @account = Account.new account_params
    redirect_to root_path unless valid_account_role @account

    if @account.save
      flash[:success] = t "accounts.create.success"
      log_in @account
      redirect_register_information @account
    else
      flash[:danger] = t "accounts.create.failure"
      @roles = [
        {value: "user", name: t("accounts.new.user")},
        {value: "company", name: t("accounts.new.company")}
      ]
      render :new
    end
  end

  private

  def redirect_register_information account
    if account.user?
      redirect_to new_user_path
    elsif account.company?
      redirect_to new_company_path
    end
  end

  def valid_account_role account
    account.user? || account.company?
  end

  def account_params
    params.require(:account).permit Account::ACCOUNT_PARAMS
  end
end
