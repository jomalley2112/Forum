# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    is_member false
    username "username"
    email "email@email.com"
    password "password"
    password_confirmation "password"
    factory :member_user do
    	is_member true
    end
  end
end
