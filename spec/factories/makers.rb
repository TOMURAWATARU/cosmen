FactoryBot.define do
  factory :maker do
    name { "UNO" }
    genre { "bbクリーム" }
    association :cosme
  end
end
