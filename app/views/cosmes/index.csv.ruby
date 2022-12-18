require 'csv'

CSV.generate do |csv|
  # 1行目にラベルを追加
  csv_column_labels = %w(名前 説明 投稿した人 参照用URL\
                         コツ・ポイント 人気度 最初に投稿した日時\
                         メーカー1の名前 メーカー1のジャンル メーカー2の名前 メーカー2のジャンル\
                         メーカー3の名前 メーカー3のジャンル\ )
  csv << csv_column_labels
  # 各コスメのカラム値を追加
  current_user.feed.each do |cosme|
    # まずメーカー以外のカラムを追加
    csv_column_values = [
      cosme.name,
      cosme.description,
      cosme.user.name,
      cosme.reference,
      cosme.tips,
      cosme.popularity,
      cosme.created_at.strftime("%Y/%m/%d(%a)")
    ]
    # メーカーの数(number_of_makers)を特定
    # 初期値を2にしておき、nameが空のメーカーが見つかったらその配列番号に置き換える
    number_of_makers = 2
    cosme.makers.each_with_index do |ing, index|
      if ing.name.empty?
        number_of_makers = index
        break
      end
    end
    # メーカーの数だけカラムを追加する
    i = 0
    while i <= number_of_makers
      csv_column_values.push(cosme.makers[i].name, cosme.makers[i].genre)
      i += 1
    end
    # 最終的なcsv_column_valuesをcsvのセルに追加
    csv << csv_column_values
  end
end