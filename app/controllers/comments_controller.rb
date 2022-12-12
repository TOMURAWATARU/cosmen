class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @cosme = Cosme.find(params[:cosme_id])
    @user = @cosme.user
    @comment = @cosme.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@cosme.nil? && @comment.save
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    @comment = Comment.find(params[:id])
    @cosme = @comment.cosme
    if current_user.id == @comment.user_id
      @comment.destroy
      flash[:success] = "コメントを削除しました"
    end
    redirect_to cosme_url(@cosme)
  end
end
