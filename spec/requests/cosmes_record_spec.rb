require "rails_helper"

RSpec.describe "コスメの登録", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:cosme) { create(:cosme, user: user) }
  let(:picture_path) { File.join(Rails.root, 'spec/fixtures/test_cosme.jpg') }
  let(:picture) { Rack::Test::UploadedFile.new(picture_path) }

  context "ログインしているユーザーの場合" do
    before do
      get new_cosme_path
      login_for_request(user)
    end

    context "フレンドリーフォワーディング" do
      it "レスポンスが正常に表示されること" do
        expect(response).to redirect_to new_cosme_url
      end
    end

    context "材料有りの料理登録" do
      it "有効なコスメデータで登録できること" do
        expect {
          post cosmes_path, params: { cosme: { name: "フェイスカラークリエイター",
                                               description: "自然な仕上がりになるものです",
                                               tips: "薄く馴染ませるのがポイント",
                                               reference: "https://brand.finetoday.com/jp/uno/products/face_color_creator/",
                                               popularity: 5,
                                               makers_attributes: [
                                                 name: "UNO",
                                                 genre: "bbクリーム" ] } }
        }.to change(Cosme, :count).by(1)
        redirect_to Cosme.first
        follow_redirect!
        expect(response).to render_template('cosmes/show')
      end

      it "メーカーのデータも同時に増えること" do
        expect {
          post cosmes_path, params: { cosme: { name: "フェイスカラークリエイター",
                                              makers_attributes: [
                                                name: "UNO",
                                                genre: "bbクリーム"] } } 
        }.to change(Maker, :count).by(1)
      end

      it "無効なコスメデータでは登録できないこと" do
        expect {
          post cosmes_path, params: { cosme: { name: "",
                                               description: "自然な仕上がりになるものです",
                                               tips: "薄く馴染ませるのがポイント",
                                               reference: "https://brand.finetoday.com/jp/uno/products/face_color_creator/",
                                               popularity: 5,
                                               makers_attributes: [
                                                 name: "UNO",
                                                 genre: "bbクリーム"] } } 
        }.not_to change(Cosme, :count)
        expect(response).to render_template('cosmes/new')
      end
    end

    context "メーカー無しのコスメ登録" do
      it "正常に完了すること" do
        expect {
          post cosmes_path, params: { cosme: { name: "フェイスカラークリエイター" } }
        }.to change(Cosme, :count).by(1)
      end

      it "メーカーのデータは増えないこと" do
        expect {
          post cosmes_path, params: { cosme: { name: "フェイスカラークリエイター" } }
        }.not_to change(Maker, :count)
      end
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get new_cosme_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
