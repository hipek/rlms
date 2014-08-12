FactoryGirl.define do
  factory :user do
    login "john"
    email "john@email.com"
    salt  '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
    crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1' # test
  end

  factory :admin, class: User do
    login       "admin"
    email       "admin@test.com"
    salt  '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
    crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1' # test
    roles       [User::ADMIN]
  end
end
