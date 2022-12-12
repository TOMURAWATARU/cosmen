class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @cosme = Cosme.find(params[:cosme_id])
    @user = @cosme.user
    current_user.favorite(@cosme)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
    # 自分以外のユーザーからお気に入り登録があったときのみ通知を作成
    if @user != current_user
       @user.notifications.create(cosme_id: @cosme.id, variety: 1,
                                  from_user_id: current_user.id) # お気に入り登録は通知種別1
       @user.update_attribute(:notification, true)
    end
  end

  def destroy
    @cosme = Cosme.find(params[:cosme_id])
    current_user.favorites.find_by(cosme_id: @cosme.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def index
    @favorites = current_user.favorites
  end
end
