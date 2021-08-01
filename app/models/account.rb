class Account < ApplicationRecord
  ACCOUNT_PARAMS = %i(email password password_confirmation role).freeze

  has_one :user, dependent: :destroy
  has_one :company, dependent: :destroy

  before_save :downcase_email

  validates :email, presence: true, uniqueness: {case_sensitive: false},
            length: {minimum: Settings.accounts.email.length.min,
                     maximum: Settings.accounts.email.length.max},
            format: {with: Settings.accounts.email.valid_regexp}
  validates :password, presence: true,
            length: {minimum: Settings.accounts.password.length.min,
                     maximum: Settings.accounts.password.length.max},
            allow_nil: true
  validates :role, presence: true

  enum role: {user: 0, company: 1, admin: 2}

  has_secure_password

  attr_accessor :remember_token

  class << self
    def digest string
      min_cost = ActiveModel::SecurePassword.min_cost
      cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = Account.new_token
    update remember_digest: Account.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  private

  def downcase_email
    email.downcase!
  end
end
