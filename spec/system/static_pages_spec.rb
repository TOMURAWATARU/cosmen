require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "めんこすの文字列が存在することを確認" do
        expect(page).to have_content 'めんこす'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end

  describe "ヘルプページ" do
    before do
      visit about_path
    end

    it "めんこすとは？の文字列が存在することを確認" do
      expect(page).to have_content 'めんこすとは？'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('めんこすとは？')
    end
  end

  describe "利用規約ページ" do
    before do
      visit use_of_terms_path
    end

    it "利用規約の文字列が存在することを確認" do
      expect(page).to have_content '利用規約'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('利用規約')
    end

    context "コスメフィード", js: true do
      let!(:user) { create(:user) }
      let!(:cosme) { create(:cosme, user: user) }
      
      before do
        login_for_system(user)
      end

      it "コスメのぺージネーションが表示されること" do
        login_for_system(user)
        create_list(:cosme, 5, user: user)
        visit root_path
        expect(page).to have_content "みんなの投稿 (#{user.cosmes.count})"
        expect(page).to have_css "div.pagination"
        Cosme.take(5).each do |d|
          expect(page).to have_link d.name
        end
      end

      it "「新しいコスメを登録する」リンクが表示されること" do
        visit root_path
        expect(page).to have_link "新しいコスメを登録する", href: new_cosme_path
      end
    end
  end
end