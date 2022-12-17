class CosmesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

  def new
    @cosme = Cosme.new
    @cosme.makers.build
  end

  def index
    @log = Log.new
     # CSV出力時のファイル名指定
    respond_to do |format|
      format.html
      format.csv {
        send_data render_to_string,
                  filename: "みんなの投稿一覧_#{Time.current.strftime('%Y%m%d_%H%M')}.csv"
      }
    end
  end

  def show
    @cosme = Cosme.find(params[:id])
    @comment = Comment.new
    @log = Log.new
  end

  def create
    @cosme = current_user.cosmes.build(cosme_params)
    if @cosme.save
      flash[:success] = "コスメが登録されました！"
      Log.create(cosme_id: @cosme.id, content: @cosme.cosme_memo)
      redirect_to cosme_path(@cosme)
    else
      render 'cosmes/new'
    end
  end

  def edit
    @cosme = Cosme.find(params[:id])
  end

  def update
    @cosme = Cosme.find(params[:id])
    if @cosme.update_attributes(cosme_params)
      flash[:success] = "コスメ情報が更新されました！"
      redirect_to @cosme
    else
      render 'edit'
    end
  end

  def destroy
    @cosme = Cosme.find(params[:id])
    if current_user.admin? || current_user?(@cosme.user)
      @cosme.destroy
      flash[:success] = "コスメが削除されました"
      redirect_to request.referrer == user_url(@cosme.user) ? user_url(@cosme.user) : root_url
    else
      flash[:danger] = "他人のコスメは削除できません"
      redirect_to root_url
    end
  end

  private

    def cosme_params
      params.require(:cosme).permit(:name, :description, :tips,
                                    :reference, :popularity, :cosme_memo, :picture,
                                     makers_attributes: [:id, :name, :genre])
    end

    def correct_user
      @cosme = current_user.cosmes.find_by(id: params[:id])
      redirect_to root_url if @cosme.nil?
    end
end
