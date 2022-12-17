require "rails_helper"

RSpec.describe "料理編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:cosme) { create(:cosme, user: user) }
  let(:picture2_path) { File.join(Rails.root, 'spec/fixtures/test_cosme2.jpg') }
  let(:picture2) { Rack::Test::UploadedFile.new(picture2_path) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること(+フレンドリーフォワーディング)" do
      get edit_cosme_path(cosme)
      login_for_request(user)
      expect(response).to redirect_to edit_cosme_url(cosme)
      patch cosme_path(cosme), params: { cosme: { name: "フェイスカラークリエイター",
                                                  description: "自然な仕上がりになるものです",
                                                  tips: "薄く馴染ませるのがポイント",
                                                  reference: "https://brand.finetoday.com/jp/uno/products/face_color_creator/",
                                                  popularity: 5,
                                                  makers_attributes:[
                                                    name: "編集-UNO",
                                                    genre: "編集-bbクリーム"] } }
      redirect_to cosme
      follow_redirect!
      expect(response).to render_template('cosmes/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      # 編集
      get edit_cosme_path(cosme)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      # 更新
      patch cosme_path(cosme), params: { cosme: { name: "フェイスカラークリエイター",
                                                  description: "自然な仕上がりになるものです",
                                                  tips: "薄く馴染ませるのがポイント",
                                                  reference: "https://brand.finetoday.com/jp/uno/products/face_color_creator/",
                                                  popularity: 5 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "別アカウントのユーザーの場合" do
    it "ホーム画面にリダイレクトすること" do
      # 編集
      login_for_request(other_user)
      get edit_cosme_path(cosme)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      # 更新
      patch cosme_path(cosme), params: { cosme: { name: "フェイスカラークリエイター",
                                                  description: "自然な仕上がりになるものです",
                                                  tips: "薄く馴染ませるのがポイント",
                                                  reference: "https://brand.finetoday.com/jp/uno/products/face_color_creator/",
                                                  popularity: 5 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
