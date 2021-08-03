module SessionsHelper
  def log_in account
    session[:account_id] = account.id
  end

  def current_account
    session_account_id = session[:account_id]
    cookies_account_id = cookies.signed[:account_id]

    if session_account_id
      @current_account ||= Account.find_by id: session_account_id
    elsif cookies_account_id
      account = Account.find_by id: cookies_account_id
      if account&.authenticated? :remember, cookies[:remember_token]
        log_in account
        @current_account = account
      end
    end
  end

  def current_owner
    redirect_to(login_path) unless logged_in?

    if current_account.user? && current_account.user
      current_account.user
    elsif current_account.company? && current_account.company
      current_account.company
    else
      root_path
    end
  end

  def logged_in?
    current_account.present?
  end

  def log_out
    forget current_account
    session.delete :account_id
    @current_account = nil
  end

  def remember account
    account.remember
    cookies.permanent.signed[:account_id] = account.id
    cookies.permanent[:remember_token] = account.remember_token
  end

  def forget account
    account.forget
    cookies.delete :account_id
    cookies.delete :remember_token
  end

  def store_location
    session[:forward_url] = request.original_url if request.get?
  end

  def redirect_back_or default
    redirect_to(session[:forward_url] || default)
    session.delete :forward_url
  end
end
