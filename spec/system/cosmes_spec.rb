require 'rails_helper'

RSpec.describe "Cosmes", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:cosme) { create(:cosme, :picture, :makers, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, cosme: cosme) }
  let!(:log) { create(:log, cosme: cosme) }

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
        expect(page).to have_css 'label[for=cosme_makers_attributes_0_name]',
                                 text: 'メーカー', count: 1
        expect(page).to have_css 'label[for=cosme_makers_attributes_0_genre]',
                                 text: 'ジャンル', count: 1
        expect(page).to have_content 'コツ・ポイント'
        expect(page).to have_content '参照用URL'
        expect(page).to have_content '人気度 [1~5]'
        expect(page).to have_content 'コスメメモ'
      end

      it "メーカー入力部分が3行表示されること" do
        expect(page).to have_css 'input.maker_name', count: 3
        expect(page).to have_css 'input.maker_genre', count: 3
      end
    end

    context "コスメ登録処理" do
      it "有効な情報でコスメ登録を行うとコスメ登録成功のフラッシュが表示されること" do
        fill_in "コスメ名", with: "フェイスカラークリエイター"
        fill_in "説明", with: "自然な仕上がりになるものです"
        fill_in "コツ・ポイント", with: "薄く馴染ませるのがポイント"
        fill_in "参照用URL", with: "https://brand.finetoday.com/jp/uno/products/face_color_creator/"
        fill_in "人気度", with: 5
        fill_in "cosme[makers_attributes][0][name]", with: "UNO"
        fill_in "cosme[makers_attributes][0][genre]", with: "bbクリーム"
        attach_file "cosme[picture]", "#{Rails.root}/spec/fixtures/test_cosme.jpg"
        click_button "登録する"
        expect(page).to have_content "コスメが登録されました！"
      end

      it "画像無しで登録すると、デフォルト画像が割り当てられること" do
        fill_in "コスメ名", with: "フェイスカラークリエイター"
        click_button "登録する"
        expect(page).to have_link(href: cosme_path(Cosme.first))
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

  describe "コスメ編集ページ" do
    before do
      login_for_system(user)
      visit cosme_path(cosme)
      click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('コスメ情報の編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'コスメ名'
        expect(page).to have_content '説明'
        expect(page).to have_css 'p.title-maker-name', text: 'メーカー（複数可）', count: 1
        expect(page).to have_css 'p.title-maker-genre', text: 'ジャンル', count: 1
        expect(page).to have_content 'コツ・ポイント'
        expect(page).to have_content '参照用URL'
        expect(page).to have_content '人気度 [1~5]'
      end

      it "メーカー入力部分が3行表示されること" do
        expect(page).to have_css 'input.maker_name', count: 3
        expect(page).to have_css 'input.maker_genre', count: 3
      end
    end


    context "コスメの更新処理" do
      it "有効な更新" do
        fill_in "コスメ名", with: "編集：フェイスカラークリエイター"
        fill_in "説明", with: "編集：自然な仕上がりになるものです"
        fill_in "コツ・ポイント", with: "編集：薄く馴染ませるのがポイント"
        fill_in "参照用URL", with: "henshu-https://brand.finetoday.com/jp/uno/products/face_color_creator/"
        fill_in "人気度", with: 1
        fill_in "cosme[makers_attributes][0][name]", with: "編集-ウーノ"
        fill_in "cosme[makers_attributes][0][genre]", with: "編集-ファンデーション"
        attach_file "cosme[picture]", "#{Rails.root}/spec/fixtures/test_cosme2.jpg"
        click_button "更新する"
        expect(page).to have_content "コスメ情報が更新されました！"
        expect(cosme.reload.name).to eq "編集：フェイスカラークリエイター"
        expect(cosme.reload.description).to eq "編集：自然な仕上がりになるものです"
        expect(cosme.reload.tips).to eq "編集：薄く馴染ませるのがポイント"
        expect(cosme.reload.reference).to eq "henshu-https://brand.finetoday.com/jp/uno/products/face_color_creator/"
        expect(cosme.reload.popularity).to eq 1
        expect(cosme.reload.makers.first.name).to eq "編集-ウーノ"
        expect(cosme.reload.makers.first.genre).to eq "編集-ファンデーション"
        expect(cosme.reload.picture.url).to include "test_cosme2.jpg"
      end

      it "無効な更新" do
        fill_in "コスメ名", with: ""
        click_button "更新する"
        expect(page).to have_content 'コスメ名を入力してください'
        expect(cosme.reload.name).not_to eq ""
      end
    end

    context "コスメの削除処理", js: true do
      it "削除成功のフラッシュが表示されること" do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'コスメが削除されました'
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

      it "コスメ情報が表示されること" do
        expect(page).to have_content cosme.name
        expect(page).to have_content cosme.description
        expect(page).to have_content cosme.tips
        expect(page).to have_content cosme.reference
        expect(page).to have_content cosme.popularity
        expect(page).to have_link nil, href: cosme_path(cosme), class: 'cosme-picture'
      end
    end

    context "コスメの削除", js: true do
      it "削除成功のフラッシュが表示されること" do
        login_for_system(user)
        visit cosme_path(cosme)
        within find('.change-cosme') do
          click_on '削除'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'コスメが削除されました'
      end
    end

    context "コメントの登録＆削除" do
      it "自分のコスメに対するコメントの登録＆削除が正常に完了すること" do
        login_for_system(user)
        visit cosme_path(cosme)
        fill_in "comment_content", with: "今日のメイクは大成功"
        click_button "コメント"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: '今日のメイクは大成功'
        end
        expect(page).to have_content "コメントを追加しました！"
        click_link "削除", href: comment_path(Comment.last)
        expect(page).not_to have_selector 'span', text: '今日のメイクは大成功'
        expect(page).to have_content "コメントを削除しました"
      end

      it "別ユーザーのコスメのコメントには削除リンクが無いこと" do
        login_for_system(other_user)
        visit cosme_path(cosme)
        within find("#comment-#{comment.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: comment.content
          expect(page).not_to have_link '削除', href: cosme_path(cosme)
        end
      end
    end

    context "ログ登録＆削除" do
      context "コスメ詳細ページから" do
        it "自分のコスメに対するログ登録＆削除が正常に完了すること" do
          login_for_system(user)
          visit cosme_path(cosme)
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "感想を追加する"
          within find("#log-#{Log.first.id}") do
            expect(page).to have_selector 'span', text: "#{cosme.logs.count}回目"
            expect(page).to have_selector 'span',
                                          text: %Q(#{Log.last.created_at.strftime("%Y/%m/%d(%a)")})
            expect(page).to have_selector 'span', text: 'ログ投稿テスト'
          end
          expect(page).to have_content "使ってみた感想を追加しました！"
          click_link "削除", href: log_path(Log.first)
          expect(page).not_to have_selector 'span', text: 'ログ投稿テスト'
          expect(page).to have_content "使ってみた感想を削除しました"
        end

        it "別ユーザーのログにはログ登録フォームが無いこと" do
          login_for_system(other_user)
          visit cosme_path(cosme)
          expect(page).not_to have_button "追加"
        end
      end

      context "トップページから" do
        it "自分のコスメに対するログ登録が正常に完了すること" do
          login_for_system(user)
          visit root_path
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          expect(Log.first.content).to eq 'ログ投稿テスト'
          expect(page).to have_content "使ってみた感想を追加しました！"
        end

        it "別ユーザーのコスメにはログ登録フォームがないこと" do
          create(:cosme, user: other_user)
          login_for_system(user)
          user.follow(other_user)
          visit root_path
          within find("#cosme-#{Cosme.first.id}") do
            expect(page).not_to have_button "追加"
          end
        end
      end

      context "プロフィールページから" do
        it "自分のコスメに対するログ登録が正常に完了すること" do
          login_for_system(user)
          visit user_path(user)
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          expect(Log.first.content).to eq 'ログ投稿テスト'
          expect(page).to have_content "使ってみた感想を追加しました！"
        end
      end
    end
  end

  context "検索機能" do
    context "ログインしている場合" do
      before do
        login_for_system(user)
        visit root_path
      end

      it "ログイン後の各ページに検索窓が表示されていること" do
        expect(page).to have_css 'form#cosme_search'
        visit about_path
        expect(page).to have_css 'form#cosme_search'
        visit use_of_terms_path
        expect(page).to have_css 'form#cosme_search'
        visit users_path
        expect(page).to have_css 'form#cosme_search'
        visit user_path(user)
        expect(page).to have_css 'form#cosme_search'
        visit edit_user_path(user)
        expect(page).to have_css 'form#cosme_search'
        visit following_user_path(user)
        expect(page).to have_css 'form#cosme_search'
        visit followers_user_path(user)
        expect(page).to have_css 'form#cosme_search'
        visit cosmes_path
        expect(page).to have_css 'form#cosme_search'
        visit cosme_path(cosme)
        expect(page).to have_css 'form#cosme_search'
        visit new_cosme_path
        expect(page).to have_css 'form#cosme_search'
        visit edit_cosme_path(cosme)
        expect(page).to have_css 'form#cosme_search'
      end

      it "フィードの中から検索ワードに該当する結果が表示されること" do
        create(:cosme, name: 'ビタミンc', user: user)
        create(:cosme, name: 'ビタミンe', user: other_user)
        create(:cosme, name: '乳液', user: user)
        create(:cosme, name: '美容液', user: other_user)

        # 誰もフォローしない場合
        fill_in 'q_name_cont', with: 'ビタミン'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”ビタミン”の検索結果：1件"
        within find('.cosmes') do
          expect(page).to have_css 'li', count: 1
        end
        fill_in 'q_name_cont', with: '液'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”液”の検索結果：1件"
        within find('.cosmes') do
          expect(page).to have_css 'li', count: 1
        end

        # other_userをフォローする場合
        user.follow(other_user)
        fill_in 'q_name_cont', with: 'ビタミン'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”ビタミン”の検索結果：2件"
        within find('.cosmes') do
          expect(page).to have_css 'li', count: 2
        end
        fill_in 'q_name_cont', with: '液'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”液”の検索結果：2件"
        within find('.cosmes') do
          expect(page).to have_css 'li', count: 2
        end
      end

      it "検索ワードを入れずに検索ボタンを押した場合、コスメ一覧が表示されること" do
        fill_in 'q_name_cont', with: ''
        click_button '検索'
        expect(page).to have_css 'h3', text: "コスメ一覧"
        within find('.cosmes') do
          expect(page).to have_css 'li', count: Cosme.count
        end
      end
    end

    context "ログインしていない場合" do
      it "検索窓が表示されないこと" do
        visit root_path
        expect(page).not_to have_css 'form#cosme_search'
      end
    end
  end
end
