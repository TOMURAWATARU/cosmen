FactoryBot.define do
  factory :list do
    from_user_id { 1 }
    association :user
    association :cosme
  end
end
