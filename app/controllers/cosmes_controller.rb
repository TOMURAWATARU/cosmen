class CosmesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

  def new
    @cosme = Cosme.new
  end

  def show
    @cosme = Cosme.find(params[:id])
  end

  def create
    @cosme = current_user.cosmes.build(cosme_params)
    if @cosme.save
      flash[:success] = "コスメが登録されました！"
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

  private

    def cosme_params
      params.require(:cosme).permit(:name, :description, :tips,
                                    :reference, :popularity, :cosme_memo)
    end

    def correct_user
      @cosme = current_user.cosmes.find_by(id: params[:id])
      redirect_to root_url if @cosme.nil?
    end
end
