FactoryBot.define do
  factory :cosme do
    name { Faker::Food.dish }
    description { "男性特有の肌悩みを速攻カバー、男性用BBクリーム。" }
    tips { "ナチュラル風にするのが今っぽい！" }
    reference { "https://brand.finetoday.com/jp/uno/products/face_color_creator_cover_lv5/" }
    popularity { 5 }
    association :user
    created_at { Time.current }
  end

  trait :makers do
    makers_attributes {
                             [
                               { name: "じゃがいも", genre: "1個" },
                               { name: "玉ねぎ", genre: "2個" },
                               { name: "ニンジン", genre: "3個" },
                             ]
    }
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

  trait :picture do
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test_cosme.jpg')) }
  end
end
