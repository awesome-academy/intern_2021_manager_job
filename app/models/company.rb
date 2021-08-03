class Company < ApplicationRecord
  COMPANY_PARAMS = %i(name address phone_number description).freeze

  belongs_to :account
  has_many :jobs, dependent: :destroy

  validates :account_id, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false},
            length: {minimum: Settings.companies.name.length.min,
                     maximum: Settings.companies.name.length.max}
  validates :address, presence: true,
            length: {minimum: Settings.companies.address.length.min,
                     maximum: Settings.companies.address.length.max}
  validates :phone_number, presence: true,
            length: {minimum: Settings.companies.phone_number.length.min,
                     maximum: Settings.companies.phone_number.length.max}
  validates :description, presence: true,
            length: {minimum: Settings.companies.description.length.min,
                     maximum: Settings.companies.description.length.max}
end
