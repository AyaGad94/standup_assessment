FactoryBot.define do
  factory :user do
    email { "MyString" }
    password_digest { "MyString" }
    full_name { "MyString" }
    team { nil }
  end
end
