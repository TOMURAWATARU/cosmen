require 'rails_helper'

RSpec.describe "ログ機能", type: :request do
  let!(:user) { create(:user) }
  let!(:cosme) { create(:cosme, user: user) }
  let!(:log) { create(:log, cosme: cosme) }

  context "ログ登録" do
    context "ログインしている場合" do
    end

    context "ログインしていない場合" do
      it "ログ登録できず、ログインページへリダイレクトすること" do
        expect {
          post logs_path, params: { cosme_id: cosme.id,
                                    log: { content: "前よりも上手く使えるようになってきた" } }
        }.not_to change(cosme.logs, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "ログ削除" do
    context "ログインしている場合" do
    end

    context "ログインしていない場合" do
      it "ログ削除はできず、ログインページへリダイレクトすること" do
        expect {
          delete log_path(log)
        }.not_to change(cosme.logs, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
