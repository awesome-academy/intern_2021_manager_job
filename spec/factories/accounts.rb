FactoryBot.define do
  factory :account do
    email {Faker::Internet.unique.email}
    password {Faker::Internet.password(min_length: 6, max_length: 50)}
    role {"user"}
    activated {true}
    confirmed_at {Time.zone.now}
    reset_password_token {Faker::Internet.password(max_length: 20)}
    confirmation_token {Faker::Internet.password(max_length: 20)}
  end
end
