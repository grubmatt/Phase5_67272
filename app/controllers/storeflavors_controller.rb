class StoreflavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @store_flavor = StoreFlavor.new
  end

  def edit
  end

  def create
    @store_flavor = StoreFlavor.new(flavor_params)
    
    if @store_flavor.save
      redirect_to store_path(@store_flavor.store), notice: "Successfully added #{@store_flavor.flavor.name} to store."
    else
      render action: 'new'
    end
  end

  def destroy
    @store_flavor.destroy
    redirect_to store_path(@store_flavor.store), notice: "Successfully removed #{@store_flavor.flavor.name} from store."
  end

  private
  def set_flavor
    @store_flavor = StoreFlavor.find(params[:id])
  end

  def flavor_params
    params.require(:employee).permit(:id, :store_id, :flavor_id)
  end

end