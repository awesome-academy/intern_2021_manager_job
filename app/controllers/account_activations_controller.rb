class AccountActivationsController < Devise::ConfirmationsController
  def create
    @referer_url = root_path
    super
  end

  def show
    @referer_url = root_path
    super
  end
end
