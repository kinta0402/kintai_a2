class BasesController < ApplicationController
  
  def index
    @bases = Base.all
  end
  
  def show
    @base = Base.find(params[:id])
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
      redirect_to bases_url
    else
      render :new
    end
  end

  
  private
  
    def base_params
      params.require(:base).permit(:base_number, :base_name, :attendance_type)
    end
end
