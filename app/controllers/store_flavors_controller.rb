class StoreFlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => :create

  def index
  end

  def new
    @store = Store.find(params[:store_id])
    @store_flavor = StoreFlavor.new
  end

  def edit
  end

  def update
  end

  def create
    @store_flavor = StoreFlavor.new(flavor_params)

    if @store_flavor.save
      redirect_to store_path(@store_flavor.store_id), notice: "Successfully added #{@store_flavor.flavor.name} to store."
    else
      render action: 'new'
    end
  end

  def destroy
    @store_flavor.destroy
    redirect_to store_path(@store_flavor.store_id), notice: "Successfully removed #{@store_flavor.flavor.name} from store."
  end

  private
  def set_flavor
    @store_flavor = StoreFlavor.find(params[:id])
  end

  def flavor_params
    params.require(:store_flavor).permit(:store_id, :flavor_id)
  end
end
