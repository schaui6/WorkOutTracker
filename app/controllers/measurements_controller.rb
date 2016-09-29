class MeasurementsController < ApplicationController
  
  def index
    @user = User.find_by(id: params[:user_id])
    @measurements = @user.measurements
  end

  def new
    @measurement = Measurement.new
    @user = User.find_by(id: params[:user_id])
    # @measurement.user_id = @user.id
  end

  def create
    @measurement = Measurement.new(measurement_params)
    @measurement.user_id = params[:user_id]
    if @measurement.save
      flash[:success] = "Measurement successfully created"
      redirect_to user_path(params[:user_id])
    else
      flash[:error] = "Measurement was not created"
      redirect_to user_path(params[:user_id])
    end
  end

  def edit
    if current_user.admin?
      @measurement = Measurement.find_by(id: params[:id])
      @user = User.find_by(id: params[:user_id])
    else
      redirect_to logout_path
    end
  end

  def update
    @measurement = Measurement.find_by(id: params[:id])
    @user = User.find_by(id: params[:user_id])
      if @measurement.update(measurement_params)
        flash[:success] = "Measurement successfully updated!"
        redirect_to user_path(@user)
      else
        flash[:error] = "Your missing a field."
        redirect_to edit_user_measurement_path(@user, @measurement)
      end
    end

    private

  def measurement_params
    params.require(:measurement).permit(:weight, :waist, :neck, :chest, :hips, :body_fat)
  end
end
