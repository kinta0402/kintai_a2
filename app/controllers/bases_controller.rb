class BasesController < ApplicationController
  
  def show
    @base = Base.find(params[:id])
  end
  
  def new
    @base = Base.new
  end
  
  def index
  end
end
