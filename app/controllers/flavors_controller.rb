class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => :create

  def index
  	@active_flavors = Flavor.active.alphabetical.paginate(page: params[:page]).per_page(10)
  	@inactive_flavors = Flavor.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def new
    @flavor = Flavor.new
  end

  def edit
  end

  def update
  end

  def create
    @flavor = Flavor.new(flavor_params)

    if @flavor.save
      redirect_to flavors_path, notice: "Successfully added #{@flavor.name} to system."
    else
      render action: 'new'
    end
  end

  def destroy
    @flavor.destroy
    redirect_to flavors_path, notice: "Successfully removed #{@flavor.name} from system."
  end

  private
  def set_flavor
    @flavor = Flavor.find(params[:id])
  end

  def flavor_params
    params.require(:flavor).permit(:name, :active)
  end
end
