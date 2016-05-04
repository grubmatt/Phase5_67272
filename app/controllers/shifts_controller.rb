class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  # load_and_authorize_resource :except => :create

  def index
  	if current_user.role?(:admin)
      @upcoming_shifts = Shift.upcoming.chronological.paginate(page: params[:page]).per_page(10)
      @incomplete_shifts = Shift.past.incomplete.chronological.paginate(page: params[:page]).per_page(10)
      @completed_shifts = Shift.past.completed.chronological.paginate(page: params[:page]).per_page(10)
    elsif current_user.role?(:manager)
      @upcoming_shifts = Shift.upcoming.for_store(current_user.store_id).chronological.paginate(page: params[:page]).per_page(10)
      @incomplete_shifts = Shift.past.incomplete.for_store(current_user.store_id).chronological.paginate(page: params[:page]).per_page(10)
      @completed_shifts = Shift.past.completed.for_store(current_user.store_id).chronological.paginate(page: params[:page]).per_page(10)
    else
      @upcoming_shifts = Shift.upcoming.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)      
      @incomplete_shifts = Shift.past.incomplete.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)
      @completed_shifts = Shift.past.completed.for_employee(current_user.employee_id).chronological.paginate(page: params[:page]).per_page(10)
    end
  end

  def new
    if current_user.role?(:admin)
      @shifts = Shift.most_recent.limit(5)
    else
      @shifts = Shift.for_store(current_user.store_id).most_recent.limit(5)
    end
    @previous_shift = Shift.last
    @shift = Shift.new
    @shift.assignment_id
  end

  def edit
  end

  def update
    if @shift.update(shift_params)
      redirect_to shifts_path, notice: "The shift has been updated."
    else
      render action: 'edit'
    end
  end

  def show
  	@shift_jobs = ShiftJob.for_shift(@shift.id).paginate(page: params[:page]).per_page(5)
  end

  def create
    @shift = Shift.new(shift_params)

    if @shift.save
      redirect_to new_shift_path, notice: "Successfully added new shift."
    else
      render action: 'new'
    end
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "Successfully removed shift."
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes)
  end
end
