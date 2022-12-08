# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "山田 太郎",
    email: "sample@example.com",
    password:              "foobar",
    password_confirmation: "foobar",
    admin: true)

99.times do |n|
name  = Faker::Name.name
email = "sample-#{n+1}@example.com"
password = "password"
User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password)
end

10.times do |n|
  Cosme.create!(name: Faker::JapaneseMedia::OnePiece.character,
                description: "男性特有の肌悩みを速攻カバー、男性用BBクリーム。",
                tips: "ナチュラル風にするのが今っぽい！",
                reference: "https://brand.finetoday.com/jp/uno/products/face_color_creator_cover_lv5/",
                popularity: 5,
                cosme_memo: "ナチュラルで自分の肌に合っている気がする！",
                user_id: 1)
end
