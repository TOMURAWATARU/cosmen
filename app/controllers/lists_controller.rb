class ListsController < ApplicationController
  before_action :logged_in_user

  def index
    @lists = current_user.lists
    @log = Log.new
  end

  def create
    @cosme = Cosme.find(params[:cosme_id])
    @user = @cosme.user
    current_user.list(@cosme)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    list = List.find(params[:list_id])
    @cosme = list.cosme
    list.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
