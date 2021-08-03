module UsersHelper
  def gender_options
    User::GENDER_HASH.keys.map{|key| [key.capitalize, key]}
  end
end
