FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    introduction { "はじめまして。私はコスメに疎いのですが、詳しくなれるように頑張りたいです！" }
    sex { "男性" }
  end
end
