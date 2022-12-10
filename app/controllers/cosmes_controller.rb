class CosmesController < ApplicationController
  before_action :logged_in_user

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

  private

    def cosme_params
      params.require(:cosme).permit(:name, :description, :tips,
                                    :reference, :popularity, :cosme_memo)
    end
end
