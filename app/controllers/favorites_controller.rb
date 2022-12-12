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
  end
  
  def destroy
    @cosme = Cosme.find(params[:cosme_id])
    current_user.favorites.find_by(cosme_id: @cosme.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
