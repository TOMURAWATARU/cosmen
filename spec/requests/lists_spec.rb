require 'rails_helper'

RSpec.describe "リスト登録機能", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:cosme) { create(:cosme, user: other_user) }

  context "リスト一覧ページの表示" do
    context "ログインしている場合" do
      it "レスポンスが正常に表示されること" do
        login_for_request(user)
        get lists_path
        expect(response).to have_http_status "200"
        expect(response).to render_template('lists/index')
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトすること" do
        get lists_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end

  context "リスト登録/解除機能" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "コスメのリスト登録/解除ができること" do
        expect {
          post "/lists/#{cosme.id}/create"
        }.to change(other_user.lists, :count).by(1)
        expect {
          delete "/lists/#{List.first.id}/destroy"
        }.to change(other_user.lists, :count).by(-1)
      end

      it "コスメのAjaxによるリスト登録/解除ができること" do
        expect {
          post "/lists/#{cosme.id}/create", xhr: true
        }.to change(other_user.lists, :count).by(1)
        expect {
          delete "/lists/#{List.first.id}/destroy", xhr: true
        }.to change(other_user.lists, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "リスト登録は実行できず、ログインページへリダイレクトすること" do
        expect {
          post "/lists/#{cosme.id}/create"
        }.not_to change(List, :count)
        expect(response).to redirect_to login_path
      end

      it "リスト解除は実行できず、ログインページへリダイレクトすること" do
        expect {
          delete "/lists/#{cosme.id}/destroy"
        }.not_to change(List, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
