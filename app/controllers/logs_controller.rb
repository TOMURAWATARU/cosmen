class LogsController < ApplicationController
  before_action :logged_in_user

  def create
    @cosme = Cosme.find(params[:cosme_id])
    @log = @cosme.logs.build(content: params[:log][:content])
    @log.save
    flash[:success] = "ログを追加しました！"
    redirect_to cosme_path(@cosme)
  end

  def destroy
    @log = Log.find(params[:id])
    @cosme = @log.cosme
    if current_user == @cosme.user
      @log.destroy
      flash[:success] = "ログを削除しました"
    end
    redirect_to cosme_url(@cosme)
  end
end
