FactoryBot.define do
  factory :favorite do
    association :cosme
    association :user
  end
end
