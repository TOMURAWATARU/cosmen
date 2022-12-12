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
  end
end
