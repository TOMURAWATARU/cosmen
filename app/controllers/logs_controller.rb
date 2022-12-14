class LogsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :create

  def create
    @cosme = Cosme.find(params[:cosme_id])
    @log = @cosme.logs.build(content: params[:log][:content])
    @log.save
    flash[:success] = "使ってみた感想を追加しました！"
    redirect_to cosme_path(@cosme)
  end

  def destroy
    @log = Log.find(params[:id])
    @cosme = @log.cosme
    if current_user == @cosme.user
      @log.destroy
      flash[:success] = "使ってみた感想を削除しました"
    end
    redirect_to cosme_url(@cosme)
  end

  private

    def correct_user
      cosme = current_user.cosmes.find_by(id: params[:cosme_id])
      redirect_to root_url if cosme.nil?
    end
end
