require 'rails_helper'

RSpec.describe Cosme, type: :model do
  let!(:cosme_yesterday) { create(:cosme, :yesterday) }
  let!(:cosme_one_week_ago) { create(:cosme, :one_week_ago) }
  let!(:cosme_one_month_ago) { create(:cosme, :one_month_ago) }
  let!(:cosme) { create(:cosme) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(cosme).to be_valid
    end

    it "名前がなければ無効な状態であること" do
      cosme = build(:cosme, name: nil)
      cosme.valid?
      expect(cosme.errors[:name]).to include("を入力してください")
    end

    it "名前が30文字以内であること" do
      cosme = build(:cosme, name: "あ" * 31)
      cosme.valid?
      expect(cosme.errors[:name]).to include("は30文字以内で入力してください")
    end

    it "説明が140文字以内であること" do
      cosme = build(:cosme, description: "あ" * 141)
      cosme.valid?
      expect(cosme.errors[:description]).to include("は140文字以内で入力してください")
    end

    it "コツ・ポイントが50文字以内であること" do
      cosme = build(:cosme, tips: "あ" * 51)
      cosme.valid?
      expect(cosme.errors[:tips]).to include("は50文字以内で入力してください")
    end

    it "ユーザーIDがなければ無効な状態であること" do
      cosme = build(:cosme, user_id: nil)
      cosme.valid?
      expect(cosme.errors[:user_id]).to include("を入力してください")
    end

    it "人気度が1以上でなければ無効な状態であること" do
      cosme = build(:cosme, popularity: 0)
      cosme.valid?
      expect(cosme.errors[:popularity]).to include("は1以上の値にしてください")
    end

    it "人気度が5以下でなければ無効な状態であること" do
      cosme = build(:cosme, popularity: 6)
      cosme.valid?
      expect(cosme.errors[:popularity]).to include("は5以下の値にしてください")
    end
  end

  context "並び順" do
    it "最も最近の投稿が最初の投稿になっていること" do
      expect(cosme).to eq Cosme.first
    end
  end
end
