class Job < ApplicationRecord
  ONLY_JOB_PARAMS = %i(name quantity salary description
                      requirement benefit status expire_at).freeze
  REASON_PARAMS = %i(id reason_content _destroy).freeze
  JOB_PARAMS = [ONLY_JOB_PARAMS,
                reason_to_joins_attributes: REASON_PARAMS].freeze

  SORT_PARAMS = ["name asc", "expire_at desc"].freeze

  belongs_to :company
  has_many :user_apply_jobs, dependent: :destroy
  has_many :users, through: :user_apply_jobs
  has_many :job_categories, dependent: :destroy
  has_many :categories, through: :job_categories
  has_many :send_notifications, class_name: Notification.name,
                  foreign_key: :sender_id, dependent: :destroy
  has_many :reason_to_joins, dependent: :destroy

  validates :company_id, presence: true
  validates :name, presence: true,
            length: {minimum: Settings.jobs.name.length.min,
                     maximum: Settings.jobs.name.length.max}
  validates :quantity, presence: true
  validates :salary, presence: true
  validates :description, presence: true,
            length: {minimum: Settings.jobs.description.length.min,
                     maximum: Settings.jobs.description.length.max}
  validates :requirement, presence: true,
            length: {minimum: Settings.jobs.requirement.length.min,
                     maximum: Settings.jobs.requirement.length.max}
  validates :benefit, presence: true,
            length: {minimum: Settings.jobs.benefit.length.min,
                     maximum: Settings.jobs.benefit.length.max}
  validates :status, :expire_at, presence: true

  accepts_nested_attributes_for :reason_to_joins, allow_destroy: true

  ransack_alias :name, :name_or_company_name

  ransacker :created_at, type: :date do
    Arel.sql("date(jobs.created_at)")
  end

  scope :newest, ->{order(created_at: :desc)}
  scope :categories_cont_all, (lambda do |category_ids|
    return if category_ids.blank?

    joins(:job_categories)
      .where("job_categories.category_id IN (?)", category_ids)
      .group("jobs.id")
      .having("COUNT(job_categories.category_id) = ?", category_ids.count)
      .distinct
  end)

  delegate :email, :name, :address, :phone_number, :account, to: :company,
           prefix: true

  def save_job_categories categories
    categories.each do |key, value|
      JobCategory.create(job_id: id, category_id: key) if value == "1"
    end
  end
end
