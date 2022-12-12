require 'rails_helper'

RSpec.describe "コメント機能", type: :request do
  let!(:user) { create(:user) }
  let!(:cosme) { create(:cosme) }
  let!(:comment) { create(:comment, user_id: user.id, cosme: cosme) }

  context "コメントの登録" do
    context "ログインしている場合" do
    end

    context "ログインしていない場合" do
      it "コメントは登録できず、ログインページへリダイレクトすること" do
        expect {
          post comments_path, params: { cosme_id: cosme.id,
                                        comment: { content: "最高です！" } }
        }.not_to change(cosme.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "コメントの削除" do
    context "ログインしている場合" do
    end

    context "ログインしていない場合" do
      it "コメントの削除はできず、ログインページへリダイレクトすること" do
        expect {
          delete comment_path(comment)
        }.not_to change(cosme.comments, :count)
      end
    end
  end
end
