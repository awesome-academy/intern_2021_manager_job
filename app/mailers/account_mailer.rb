class AccountMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: "account_mailer"

  def reset_password_instructions record, token, opts = {}
    super
  end

  def confirmation_instructions record, token, opts = {}
    super
  end
end
