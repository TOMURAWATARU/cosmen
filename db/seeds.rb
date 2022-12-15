# ユーザー
User.create!(
    [
      {
        name:  "山田 一郎",
        email: "yamayama@example.com",
        password:              "foobar",
        password_confirmation: "foobar",
        admin: true,
      },
      {
        name:  "鈴木 太郎",
        email: "suzukin@example.com",
        password:              "password",
        password_confirmation: "password",
      },
      {
        name:  "採用 二郎",
        email: "recruit@example.com",
        password:              "password",
        password_confirmation: "password",
      },
    ]
  )
  
  # フォロー関係
  user1 = User.find(1)
  user2 = User.find(2)
  user3 = User.find(3)
  user3.follow(user1)
  user3.follow(user2)
  
  # コスメ
  description1 = "男性特有の肌悩みをカバーしてくれます"
  description2 = "誰にでも合いそうな感じです。"
  description3 = "ナチュラルな香りです。"
  tips1 = "ナチュラル風にするのが今っぽい！"
  tips2 = "あまりつけすぎない"
  tips3 = "薄めに塗るのがいい！"
  cosme_memo1 = "ナチュラルで自分の肌に合っている気がする！"
  cosme_memo2 = "長時間持つのでオススメ"
  cosme_memo3 = "いい匂いがする！"
  
  ## 3ユーザー、それぞれ3コスメずつ作成
  Cosme.create!(
    [
      {
        name: "フェイスカラークリエイター",
        user_id: 1,
        description: description1,
        tips: tips1,
        reference: "https://brand.finetoday.com/jp/uno/products/face_color_creator_cover_lv5/",
        popularity: 3,
        cosme_memo: cosme_memo1,
        picture: open("#{Rails.root}/public/images/cosme1.jpg"),
        makers_attributes: [ { name: "UNO", genre: "bbクリーム" } ],
      },
      {
        name: "ザBB(カバー&モイストコーティング)",
        user_id: 2,
        description: description2,
        tips: tips2,
        reference: "https://www.cosme.com/products/detail.php?product_id=265089",
        popularity: 4,
        cosme_memo: cosme_memo1,
        picture: open("#{Rails.root}/public/images/cosme2.jpg"),
        makers_attributes: [ { name: "ケイト", genre: "bbクリーム" } ],
      },
      {
        name: "レプリカ オードトワレ レイジーサンデー モーニング",
        user_id: 3,
        description: description3,
        tips: tips3,
        reference: "https://www.cosme.com/products/detail.php?product_id=197275",
        popularity: 4,
        cosme_memo: cosme_memo1,
        picture: open("#{Rails.root}/public/images/cosme3.jpg"),
        makers_attributes: [ { name: "メゾンマルジェラフレグランス", genre: "香水" } ],
      },
      {
        name: "ザ・タイムR アクア ",
        user_id: 1,
        description: description2,
        tips: tips2,
        reference: "https://www.cosme.net/product/product_id/10079040/top",
        cosme_memo: cosme_memo2,
        picture: open("#{Rails.root}/public/images/cosme4.jpg"),
        makers_attributes: [ { name: "イプサ", genre: "化粧水" } ],
      },
      {
        name: "ジェニフィック アドバンスト N",
        user_id: 2,
        description: description3,
        tips: tips2,
        reference: "https://www.cosme.net/product/product_id/10173118/top",
        popularity: 5,
        cosme_memo: cosme_memo3,
        picture: open("#{Rails.root}/public/images/cosme5.jpg"),
        makers_attributes: [ { name: "ランコム", genre: "美容液" } ],
      },
      {
        name: "ドラマティックパウダリーEX",
        user_id: 3,
        description: description2,
        tips: tips2,
        reference: "https://www.cosme.net/product/product_id/10202423/sku/1080825#image-609226",
        popularity: 3,
        cosme_memo: cosme_memo2,
        picture: open("#{Rails.root}/public/images/cosme6.jpg"),
        makers_attributes: [ { name: "マキアージュ", genre: "ファンデーション" } ],
      },
      {
        name: "ホワイトリリー オードパルファン",
        user_id: 1,
        description: description3,
        tips: tips3,
        reference: "https://www.cosme.net/product/product_id/10077215/sku/1042205",
        popularity: 5,
        cosme_memo: cosme_memo1,
        picture: open("#{Rails.root}/public/images/cosme7.jpg"),
        makers_attributes: [ { name: "SHIRO", genre: "香水" } ],
      },
      {
        name: "カネボウ ヴェイル オブ デイ",
        user_id: 2,
        description: description2,
        tips: tips2,
        reference: "https://www.cosme.net/product/product_id/10218271/sku/1109261#image-659388",
        popularity: 4,
        cosme_memo: cosme_memo2,
        picture: open("#{Rails.root}/public/images/cosme8.jpg"),
        makers_attributes: [ { name: "カネボウ", genre: "美容液" } ],
      },
      {
        name: "THE TONER",
        user_id: 3,
        description: description3,
        tips: tips3,
        reference: "https://www.cosme.net/product/product_id/10060377/top",
        popularity: 5,
        cosme_memo: cosme_memo3,
        picture: open("#{Rails.root}/public/images/cosme9.jpg"),
        makers_attributes: [ { name: "BULK HOMME", genre: "化粧水" } ],
      },
    ]
  )
  
  cosme1 = Cosme.find(1)
  cosme2 = Cosme.find(2)
  cosme3 = Cosme.find(3)
  cosme4 = Cosme.find(4)
  cosme5 = Cosme.find(5)
  cosme6 = Cosme.find(6)
  cosme7 = Cosme.find(7)
  cosme8 = Cosme.find(8)
  cosme9 = Cosme.find(9)
  
  # お気に入り登録
  user3.favorite(cosme6)
  user3.favorite(cosme7)
  user1.favorite(cosme9)
  user2.favorite(cosme2)
  
  # コメント
  cosme9.comments.create(user_id: user1.id, content: "すごい良さそう！")
  cosme2.comments.create(user_id: user2.id, content: "使うの楽しみ！")
  
  # 通知
  user3.notifications.create(user_id: user3.id, cosme_id: cosme9.id,
                             from_user_id: user1.id, variety: 1)
  user3.notifications.create(user_id: user3.id, cosme_id: cosme9.id,
                             from_user_id: user1.id, variety: 2, content: "すごい良さそう！")
  user3.notifications.create(user_id: user3.id, cosme_id: cosme2.id,
                             from_user_id: user2.id, variety: 1)
  user3.notifications.create(user_id: user3.id, cosme_id: cosme2.id,
                             from_user_id: user2.id, variety: 2, content: "使うの楽しみ！")
  # リスト
  user3.list(cosme3)
  user1.list(cosme9)
  user3.list(cosme8)
  user2.list(cosme2)
  
  # ログ
  Cosme.all.each do |cosme|
    Log.create!(cosme_id: cosme.id,
                content: cosme.cosme_memo)
  end
