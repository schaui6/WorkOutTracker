class MeasurementsController < ApplicationController
  
  def index
    @user = User.find_by(id: params[:user_id])
    @measurements = @user.measurements
    @last_measurement = @measurements.last
    @low_int_target_zone = find_low_int_target_hr(find_max_hr(@last_measurement))
    @high_int_target_zone = find_high_int_target_hr(find_max_hr(@last_measurement))
    @bmi = find_BMI(@last_measurement)
    @bmr = find_BMR(@last_measurement)
    @body_fat= find_body_fat(@last_measurement)
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
    params.require(:measurement).permit(:weight, :waist, :neck, :chest, :hips, :body_fat, :photo, :age, :height, :gender, :forearm, :wrist)
  end

  def find_max_hr(measurement)
    if measurement.nil?
      return "Need to add a measurement"
    else
      220 - measurement.age
    end
  end

  def find_low_int_target_hr(max_hr=0)
    max_hr.to_f * 0.70
  end

  def find_high_int_target_hr(max_hr=0)
    max_hr.to_f * 0.85
  end 

  def in_to_m(inches=0)
    inches.to_f / 39.370
  end

  def in_to_cm(inches=0)
    inches.to_f * 2.54
  end

  def lbs_to_kg(lbs=0)
    lbs.to_f / 2.2046226218
  end

  def find_BMI(measurement)
    if measurement.nil?
      return 0
    else
    ( ( lbs_to_kg(measurement.weight) / in_to_m(measurement.height) ) / in_to_m(measurement.height) )
    end
  end

  def find_BMR(measurement)
    if measurement != nil
    converted_weight =  10 * lbs_to_kg(measurement.weight) 
    converted_height =  6.25 * in_to_cm(measurement.height)
    converted_age = 5 * measurement.age
      if measurement.gender == "male"
        bmr = converted_weight + converted_height - converted_age + 5
        return bmr
      else
        bmr = converted_weight + converted_height - converted_age - 161
        return bmr
      end
    end
  end

  def find_body_fat(measurement)
    if measurement != nil
      converted_weight = 1.082 * measurement.weight
      converted_waist = 4.15 * measurement.waist
      added_converted_weight = 94.42 + converted_weight

      if measurement.gender == "male"
        # calculation is slightly off
        lean_body_weight = added_converted_weight - converted_waist
        lean_diff = measurement.weight - lean_body_weight
        lean_diff_times_100 = lean_diff * 100
        body_fat = lean_diff_times_100 / measurement.weight
        return body_fat
      else
        weight_kg = measurement.weight / 2.2
        multipy_weight = 0.732 * weight_kg
        wrist_cm = measurement.wrist / 0.394
        multipy_wrist = 3.786 * wrist_cm
        forearm_circumference = measurement.forearm / 3.14
        multipy_forearm = 0.434 * forearm_circumference
        lean_body_weight = 8.987 + multipy_weight + multipy_wrist + multipy_forearm
        lean_diff = measurement.weight - lean_body_weight
        lean_diff_times_100 = lean_diff * 100
        body_fat = lean_diff_times_100 / measurement.weight
        return body_fat
      end
    else
      body_fat = 0.0
      return body_fat
    end
  end
end
