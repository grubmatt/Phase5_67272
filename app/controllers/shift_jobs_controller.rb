class ShiftJobsController < ApplicationController
  before_action :set_shift_job, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:create,:new_shift_job]

  def index
  end

  def new
    @shift = Shift.find(params[:shift_id])
    @shift_job = ShiftJob.new
    @shift_job.shift_id = params[:shift_id]
  end

  def edit
  end

  def update
  end

  def create
    @shift_job = ShiftJob.new(shift_job_params)

    if @shift_job.save
      redirect_to shift_path(@shift_job.shift_id), notice: "Successfully added #{@shift_job.job.name} to shift."
    else
      render action: 'new'
    end
  end

  def destroy
    @shift_id = @shift_job.shift_id
    @shift_job.destroy
    redirect_to shift_path(@shift_id), notice: "Successfully removed #{@shift_job.job.name} from shift."
  end

  private
  def set_shift_job
    @shift_job = ShiftJob.find(params[:id])
  end

  def shift_job_params
    params.require(:shift_job).permit(:shift_id, :job_id)
  end
end
