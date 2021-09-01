class PasswordResetsController < Devise::PasswordsController
  def new
    super
  end

  def create
    @referer_url = root_path
    super
  end

  def edit
    super
  end

  def update
    @referer_url = root_path
    super
  end
end
