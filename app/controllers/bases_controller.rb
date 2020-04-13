class BasesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  
  def index
    @bases = Base.all.order(:base_number)
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
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_url
    else
      render :edit
    end
  end
  
  def destroy
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "拠点番号 #{@base.base_number} のデータを削除しました。"
    redirect_to bases_url
  end


  private
  
    def base_params
      params.require(:base).permit(:base_number, :base_name, :attendance_type)
    end
end
