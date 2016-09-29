class MeasurementsController < ApplicationController
  
  def index
    @user = User.find_by(id: params[:user_id])
    @measurements = @user.measurements
    @last_measurement = @measurements.last
    @low_int_target_zone = find_low_int_target_hr(find_max_hr(@last_measurement))
    @high_int_target_zone = find_high_int_target_hr(find_max_hr(@last_measurement))
    @bmi = find_BMI(@last_measurement)
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
    params.require(:measurement).permit(:weight, :waist, :neck, :chest, :hips, :body_fat, :photo, :age, :height)
  end

  def find_max_hr(measurement)
    220 - measurement.age
  end

  def find_low_int_target_hr(max_hr)
    max_hr * 0.70
  end

  def find_high_int_target_hr(max_hr)
    max_hr * 0.85
  end 

  def in_to_m(inches)
    inches / 39.370
  end

  def lbs_to_kg(lbs)
    lbs / 2.2046226218
  end

  def find_BMI(measurement)
    ( ( lbs_to_kg(measurement.weight) / in_to_m(measurement.height) ) / in_to_m(measurement.height) )
  end
end
