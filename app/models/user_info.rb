class UserInfo < ApplicationRecord
  USER_INFO_PARAMS = %i(objective work_experiences
                        educations skills interests).freeze
  belongs_to :user

  validates :user_id, presence: true
  validates :objective,
            length: {minimum: Settings.user_infos.objective.length.min,
                     maximum: Settings.user_infos.objective.length.max}
  validates :work_experiences,
            length: {minimum: Settings.user_infos.work_experiences.length.min,
                     maximum: Settings.user_infos.work_experiences.length.max}
  validates :educations,
            length: {minimum: Settings.user_infos.educations.length.min,
                     maximum: Settings.user_infos.educations.length.max}
  validates :skills,
            length: {minimum: Settings.user_infos.skills.length.min,
                     maximum: Settings.user_infos.skills.length.max}
  validates :interests,
            length: {minimum: Settings.user_infos.interests.length.min,
                     maximum: Settings.user_infos.interests.length.max}
end
