require 'rails_helper'

RSpec.describe "Cosmes", type: :system do
  let!(:user) { create(:user) }
  let!(:cosme) { create(:cosme, user: user) }

  describe "コスメ登録ページ" do
    before do
      login_for_system(user)
      visit new_cosme_path
    end

    context "ページレイアウト" do
      it "「コスメ登録」の文字列が存在すること" do
        expect(page).to have_content 'コスメ登録'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('コスメ登録')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'コスメ名'
        expect(page).to have_content '説明'
        expect(page).to have_content 'コツ・ポイント'
        expect(page).to have_content '参照用URL'
        expect(page).to have_content '人気度 [1~5]'
        expect(page).to have_content 'コスメメモ'
      end
    end

    context "コスメ登録処理" do
      it "有効な情報でコスメ登録を行うとコスメ登録成功のフラッシュが表示されること" do
        fill_in "コスメ名", with: "ファンデーション"
        fill_in "説明", with: "自然な仕上がりになるものです"
        fill_in "コツ・ポイント", with: "薄く馴染ませるのがポイント"
        fill_in "参照用URL", with: "https://brand.finetoday.com/jp/uno/products/face_color_creator/"
        fill_in "人気度", with: 5
        click_button "登録する"
        expect(page).to have_content "コスメが登録されました！"
      end

      it "無効な情報でコスメ登録を行うとコスメ登録失敗のフラッシュが表示されること" do
        fill_in "コスメ名", with: ""
        fill_in "説明", with: "自然な仕上がりになるものです"
        fill_in "コツ・ポイント", with: "薄く馴染ませるのがポイント"
        fill_in "参照用URL", with: "https://brand.finetoday.com/jp/uno/products/face_color_creator/"
        fill_in "人気度", with: 5
        click_button "登録する"
        expect(page).to have_content "コスメ名を入力してください"
      end
    end
  end

  describe "コスメ詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit cosme_path(cosme)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{cosme.name}")
      end

      it "料理情報が表示されること" do
        expect(page).to have_content cosme.name
        expect(page).to have_content cosme.description
        expect(page).to have_content cosme.tips
        expect(page).to have_content cosme.reference
        expect(page).to have_content cosme.popularity
      end
    end
  end
end
