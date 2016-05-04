class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  # load_and_authorize_resource :except => :create

  def index
  	if current_user.role?(:admin)
      @current_shifts = Shift.upcoming.by_store.chronological.paginate(page: params[:page]).per_page(10)
      @incomplete_shifts = Shift.past.incomplete.by_store.chronological.paginate(page: params[:page]).per_page(10)
      @complete_shifts = Shift.past.completed.by_store.chronological.paginate(page: params[:page]).per_page(10)
    elsif current_user.role?(:manager)
      @current_shifts = Shift.upcoming.for_store(current_user.store_id).chronological.paginate(page: params[:page]).per_page(10)
      @incomplete_shifts = Shift.past.incomplete.for_store(current_user.store_id).chronological.paginate(page: params[:page]).per_page(10)
      @complete_shifts = Shift.past.completed.for_store(current_user.store_id).chronological.paginate(page: params[:page]).per_page(10)
    else
      @current_shifts = Shift.upcoming.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)      
      @incomplete_shifts = Shift.past.incomplete.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)
      @complete_shifts = Shift.past.completed.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)
    end
  end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def update
  end

  def create
    @shift = Shift.new(shift_params)

    if @shift.save
      redirect_to shift_path(@shift), notice: "Successfully added new shift."
    else
      render action: 'new'
    end
  end

  def destroy
    @shift.destroy
    redirect_to shift_path(@shift), notice: "Successfully removed shift."
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes)
  end
end
