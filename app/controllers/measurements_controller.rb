class MeasurementsController < ApplicationController
  
  def index
    @user = User.find_by(id: params[:user_id])
    @measurements = @user.measurements
    @low_int_target_zone = find_low_int_target_hr
    @high_int_target_zone = find_high_int_target_hr
    @bmi = find_BMI
    @bmr = find_BMR
    @body_fat= find_body_fat
  end

  def new
    @measurement = Measurement.new
    @user = User.find_by(id: params[:user_id])
  end

  def create
    @measurement = Measurement.new(measurement_params)
    @measurement.weight = user_weight
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
        flash[:error] = "You're missing a field."
        redirect_to edit_user_measurement_path(@user, @measurement)
      end
    end

  private

  def user_age
    user = User.find_by(id: params[:user_id])
    return user.age
  end

  def user_waist
    user = User.find_by(id: params[:user_id])
    return user.waist
  end

  def user_wrist
    user = User.find_by(id: params[:user_id])
    return user.wrist
  end

  def user_forearm
    user = User.find_by(id: params[:user_id])
    return user.forearm
  end

  def user_weight
    user = User.find_by(id: params[:user_id])
    return user.weight
  end

  def measurement_params
    params.require(:measurement).permit(:weight, :waist, :neck, :chest, :hips, :body_fat, :photo, :age, :height, :gender, :forearm, :wrist)
  end

  def max_hr
    220 - user_age
  end

  def find_low_int_target_hr
    max_hr.to_f * 0.70
  end

  def find_high_int_target_hr
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

  def find_BMI
    ( ( lbs_to_kg(user_weight) / in_to_m(user_height) ) / in_to_m(user_height) )
  end

  def user_gender
    user = User.find_by(id: params[:user_id])
    return user.gender
  end

  def user_height
    user = User.find_by(id: params[:user_id])
    return user.height
  end

  def bmr_data
    converted_weight =  10 * lbs_to_kg(user_weight) 
    converted_height =  6.25 * in_to_cm(user_height)
    converted_age = 5 * user_age
    return converted_weight + converted_height - converted_age
  end

  def find_BMR
    if user_gender == "male"
      bmr = bmr_data + 5
      return bmr
    else
      bmr = bmr_data - 161
      return bmr
    end
  end

  # calculation is slightly off
  def male_body_fat
    converted_weight = 1.082 * user_weight
    converted_waist = 4.15 * user_waist
    added_converted_weight = 94.42 + converted_weight
    lean_body_weight = added_converted_weight - converted_waist
    lean_diff = user_weight - lean_body_weight
    lean_diff_times_100 = lean_diff * 100
    body_fat = lean_diff_times_100 / user_weight
    return body_fat
  end

  # calculation is slightly off
  def female_body_fat
    weight_kg = user_weight / 2.2
    multipy_weight = 0.732 * weight_kg
    wrist_cm = user_wrist / 0.394
    multipy_wrist = 3.786 * wrist_cm
    forearm_circumference = user_forearm / 3.14
    multipy_forearm = 0.434 * forearm_circumference
    lean_body_weight = 8.987 + multipy_weight + multipy_wrist + multipy_forearm
    lean_diff = user_weight - lean_body_weight
    lean_diff_times_100 = lean_diff * 100
    body_fat = lean_diff_times_100 / user_weight
    return body_fat
  end

  # calculation is slightly off
  def find_body_fat
    user_gender == "male" ? male_body_fat : female_body_fat
  end
end
