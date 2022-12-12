require 'rails_helper'

RSpec.describe "お気に入り登録機能", type: :request do
  let(:user) { create(:user) }
  let(:cosme) { create(:cosme) }

  context "お気に入り登録処理" do
    context "ログインしていない場合" do
      it "お気に入り登録は実行できず、ログインページへリダイレクトすること" do
        expect {
          post "/favorites/#{cosme.id}/create"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end

      it "お気に入り解除は実行できず、ログインページへリダイレクトすること" do
        expect {
          delete "/favorites/#{cosme.id}/destroy"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
    end

    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "コスメのお気に入り登録ができること" do
        expect {
          post "/favorites/#{cosme.id}/create"
        }.to change(user.favorites, :count).by(1)
      end

      it "コスメのAjaxによるお気に入り登録ができること" do
        expect {
          post "/favorites/#{cosme.id}/create", xhr: true
        }.to change(user.favorites, :count).by(1)
      end

      it "コスメのお気に入り解除ができること" do
        user.favorite(cosme)
        expect {
          delete "/favorites/#{cosme.id}/destroy"
        }.to change(user.favorites, :count).by(-1)
      end

      it "コスメのAjaxによるお気に入り解除ができること" do
        user.favorite(cosme)
        expect {
          delete "/favorites/#{cosme.id}/destroy", xhr: true
        }.to change(user.favorites, :count).by(-1)
      end
    end
  end
end
