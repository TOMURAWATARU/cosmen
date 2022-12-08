FactoryBot.define do
  factory :cosme do
    name { Faker::JapaneseMedia::OnePiece }
    description { "男性特有の肌悩みを速攻カバー、男性用BBクリーム。
      特に毛穴・ニキビ跡にしっかりカバー" }
    tips { "ナチュラル風にするのが今っぽい！" }
    reference { "https://brand.finetoday.com/jp/uno/products/face_color_creator_cover_lv5/" }
    popularity { 5 }
    association :user
    created_at { Time.current }
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end

  trait :one_week_ago do
    created_at { 1.week.ago }
  end

  trait :one_month_ago do
    created_at { 1.month.ago }
  end
end
