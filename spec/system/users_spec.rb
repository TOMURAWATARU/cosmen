require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_user) { create(:user) }
  let!(:cosme) { create(:cosme, user: user) }
  let!(:other_cosme) { create(:cosme, user: other_user) }

  describe "ユーザー一覧ページ" do
    context "管理者ユーザーの場合" do
      it "ぺージネーション、自分以外のユーザーの削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | 削除" unless u == admin_user
        end
      end
    end

    context "管理者ユーザー以外の場合" do
      it "ぺージネーション、自分のアカウントのみ削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if u == user
            expect(page).to have_content "#{u.name} | 削除"
          else
            expect(page).not_to have_content "#{u.name} | 削除"
          end
        end
      end
    end
  end

  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    context "ページレイアウト" do
      it "「ユーザー登録」の文字列が存在することを確認" do
        expect(page).to have_content 'ユーザー登録'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('ユーザー登録')
      end
    end

    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うとユーザー登録成功のフラッシュが表示されること" do
        fill_in "ユーザー名", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
        expect(page).to have_content "めんこすへようこそ！"
      end

      it "無効なユーザーでユーザー登録を行うとユーザー登録失敗のフラッシュが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "pass"
        click_button "登録する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "プロフィール編集ページ" do
    before do
      login_for_system(user)
      visit user_path(user)
      click_link "プロフィール編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール編集')
      end
    end

    it "有効なプロフィール更新を行うと、更新成功のフラッシュが表示されること" do
      fill_in "ユーザー名", with: "Edit Example User"
      fill_in "メールアドレス", with: "edit-user@example.com"
      fill_in "自己紹介", with: "編集：初めまして"
      fill_in "性別", with: "編集：男性"
      click_button "更新する"
      expect(page).to have_content "プロフィールが更新されました！"
      expect(user.reload.name).to eq "Edit Example User"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.introduction).to eq "編集：初めまして"
      expect(user.reload.sex).to eq "編集：男性"
    end

    it "無効なプロフィール更新をしようとすると、適切なエラーメッセージが表示されること" do
      fill_in "ユーザー名", with: ""
      fill_in "メールアドレス", with: ""
      click_button "更新する"
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'メールアドレスは不正な値です'
      expect(user.reload.email).not_to eq ""
    end

    context "アカウント削除処理", js: true do
      it "正しく削除できること" do
        click_link "アカウントを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "自分のアカウントを削除しました"
      end
    end
  end

  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        create_list(:cosme, 10, user: user)
        visit user_path(user)
      end

      it "「プロフィール」の文字列が存在することを確認" do
        expect(page).to have_content 'プロフィール'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
        expect(page).to have_content user.sex
      end

      it "プロフィール編集ページへのリンクが表示されていることを確認" do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end

      it "コスメの件数が表示されていることを確認" do
        expect(page).to have_content "コスメ (#{user.cosmes.count})"
      end

      it "コスメの情報が表示されていることを確認" do
        Cosme.take(4).each do |cosme|
          expect(page).to have_link cosme.name
          expect(page).to have_content cosme.description
          expect(page).to have_content cosme.user.name
          expect(page).to have_content cosme.popularity
          cosme.makers.each do |i|
            expect(page).to have_content i.name
            expect(page).to have_content i.genre
          end
        end
      end

      it "コスメのページネーションが表示されていることを確認" do
        expect(page).to have_css "div.pagination"
      end
    end

    context "ユーザーのフォロー/アンフォロー処理", js: true do
      it "ユーザーのフォロー/アンフォローができること" do
        login_for_system(user)
        visit user_path(other_user)
        expect(page).to have_button 'フォローする'
        click_button 'フォローする'
        expect(page).to have_button 'フォロー中'
        click_button 'フォロー中'
        expect(page).to have_button 'フォローする'
      end
    end

    context "お気に入り登録/解除" do
      before do
        login_for_system(user)
      end

      it "コスメのお気に入り登録/解除ができること" do
        expect(user.favorite?(cosme)).to be_falsey
        user.favorite(cosme)
        expect(user.favorite?(cosme)).to be_truthy
        user.unfavorite(cosme)
        expect(user.favorite?(cosme)).to be_falsey
      end

      it "トップページからお気に入り登録/解除ができること", js: true do
        visit root_path
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{cosme.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{cosme.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{cosme.id}/create"
      end

      it "ユーザー個別ページからお気に入り登録/解除ができること", js: true do
        visit user_path(user)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{cosme.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{cosme.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{cosme.id}/create"
      end

      it "コスメ個別ページからお気に入り登録/解除ができること", js: true do
        visit cosme_path(cosme)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{cosme.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{cosme.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{cosme.id}/create"
      end

      it "お気に入り一覧ページが期待通り表示されること" do
        visit favorites_path
        expect(page).not_to have_css ".favorite-cosme"
        user.favorite(cosme)
        user.favorite(other_cosme)
        visit favorites_path
        expect(page).to have_css ".favorite-cosme", count: 2
        expect(page).to have_content cosme.name
        expect(page).to have_content cosme.description
        expect(page).to have_content "by #{user.name}"
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content other_cosme.name
        expect(page).to have_content other_cosme.description
        expect(page).to have_content "by #{other_user.name}"
        expect(page).to have_link other_user.name, href: user_path(other_user)
        user.unfavorite(other_cosme)
        visit favorites_path
        expect(page).to have_css ".favorite-cosme", count: 1
        expect(page).to have_content cosme.name
      end
    end

    context "通知生成" do
      before do
        login_for_system(user)
      end

      context "自分以外のユーザーのコスメに対して" do
        before do
          visit cosme_path(other_cosme)
        end

        it "お気に入り登録によって通知が作成されること" do
          find('.like').click
          visit cosme_path(other_cosme)
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content "あなたのコスメが#{user.name}さんにお気に入り登録されました。"
          expect(page).to have_content other_cosme.name
          expect(page).to have_content other_cosme.description
          expect(page).to have_content other_cosme.created_at.strftime("%Y/%m/%d(%a) %H:%M")
        end

        it "コメントによって通知が作成されること" do
          fill_in "comment_content", with: "コメントしました"
          click_button "コメント"
          expect(page).to have_css 'li.no_notification'
          logout
          login_for_system(other_user)
          expect(page).to have_css 'li.new_notification'
          visit notifications_path
          expect(page).to have_css 'li.no_notification'
          expect(page).to have_content "あなたのコスメに#{user.name}さんがコメントしました。"
          expect(page).to have_content '「コメントしました」'
          expect(page).to have_content other_cosme.name
          expect(page).to have_content other_cosme.description
          expect(page).to have_content other_cosme.created_at.strftime("%Y/%m/%d(%a) %H:%M")
        end
      end

      context "自分のコスメに対して" do
        before do
          visit cosme_path(cosme)
        end

        it "お気に入り登録によって通知が作成されないこと" do
          find('.like').click
          visit cosme_path(cosme)
          expect(page).to have_css 'li.no_notification'
          visit notifications_path
          expect(page).not_to have_content 'お気に入りに登録されました。'
          expect(page).not_to have_content cosme.name
          expect(page).not_to have_content cosme.description
          expect(page).not_to have_content cosme.created_at
        end

        it "コメントによって通知が作成されないこと" do
          fill_in "comment_content", with: "自分でコメント"
          click_button "コメント"
          expect(page).to have_css 'li.no_notification'
          visit notifications_path
          expect(page).not_to have_content 'コメントしました。'
          expect(page).not_to have_content '自分でコメント'
          expect(page).not_to have_content other_cosme.name
          expect(page).not_to have_content other_cosme.description
          expect(page).not_to have_content other_cosme.created_at
        end
      end
    end
  end

  context "リスト登録/解除" do
    before do
      login_for_system(user)
    end

    it "コスメのお気に入り登録/解除ができること" do
      expect(user.list?(cosme)).to be_falsey
      user.list(cosme)
      expect(user.list?(cosme)).to be_truthy
      user.unlist(List.first)
      expect(user.list?(cosme)).to be_falsey
    end

    it "トップページからリスト登録/解除ができること", js: true do
      visit root_path
      link = find('.list')
      expect(link[:href]).to include "/lists/#{cosme.id}/create"
      link.click
      link = find('.unlist')
      expect(link[:href]).to include "/lists/#{List.first.id}/destroy"
      link.click
      link = find('.list')
      expect(link[:href]).to include "/lists/#{cosme.id}/create"
    end

    it "ユーザー個別ページからリスト登録/解除ができること", js: true do
      visit user_path(user)
      link = find('.list')
      expect(link[:href]).to include "/lists/#{cosme.id}/create"
      link.click
      link = find('.unlist')
      expect(link[:href]).to include "/lists/#{List.first.id}/destroy"
      link.click
      link = find('.list')
      expect(link[:href]).to include "/lists/#{cosme.id}/create"
    end

    it "コスメ個別ページからリスト登録/解除ができること", js: true do
      link = find('.list')
      expect(link[:href]).to include "/lists/#{cosme.id}/create"
      link.click
      link = find('.unlist')
      expect(link[:href]).to include "/lists/#{List.first.id}/destroy"
      link.click
      link = find('.list')
      expect(link[:href]).to include "/lists/#{cosme.id}/create"
    end

    it "リスト一覧ページが期待通り表示され、リストから削除することもできること" do
      visit lists_path
      expect(page).not_to have_css ".list-cosme"
      user.list(cosme)
      cosme_2 = create(:cosme, user: user)
      other_user.list(cosme_2)
      visit lists_path
      expect(page).to have_css ".list-cosme", count: 2
      expect(page).to have_content cosme.name
      expect(page).to have_content cosme.description
      expect(page).to have_content List.last.created_at.strftime("%Y/%m/%d(%a) %H:%M")
      expect(page).to have_content "このコスメをイチオシリストに追加しました。"
      expect(page).to have_content cosme_2.name
      expect(page).to have_content cosme_2.description
      expect(page).to have_content List.first.created_at.strftime("%Y/%m/%d(%a) %H:%M")
      expect(page).to have_content "#{other_user.name}さんがこのコスメに買いたいリクエストをしました。"
      expect(page).to have_link other_user.name, href: user_path(other_user)
      user.unlist(List.first)
      visit lists_path
      expect(page).to have_css ".list-cosme", count: 1
      expect(page).to have_content cosme.name
      find('.unlist').click
      visit lists_path
      expect(page).not_to have_css ".list-cosme"
    end
  end
end
