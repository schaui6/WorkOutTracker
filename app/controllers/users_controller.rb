class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_user, only: [:show]
  before_action :require_admin, only: [:index, :destroy]

  def index
    @users = User.where(admin: false)
  end

  def show
    @user = User.find_by(id: params[:id])
    @phases = phases(@user) if @user
    @phases.sort!
    if @user.nil?
       if current_user.admin?
        flash[:error] = "User doesn't exist!" 
        redirect_to users_path 
      else
        flash[:error] = "You don't have access!" 
        redirect_to user_path(session[:user_id])
      end

    elsif current_user.admin?
      @admin = current_user
      if @user.workouts && @user
       @workouts = @user.workouts
       render 'users/show', :locals => {:phases => @phases, workouts: @workouts }
      end
    else
      # Prevents clients to see other client's data###################
      unless session[:user_id] == @user.id
        flash[:error] = "You don't have access!"
        redirect_to user_path(session[:user_id])
      return
      end
      #################################################
      @workouts = current_user.workouts
      @user.body_fat = find_body_fat
      render 'users/show', :locals => {phases: @phases, workouts: @workouts }
    end
  end


  def new
    @user = User.new
  end

  def create
    
    if @user = User.new(user_params)

      measurement = Measurement.new( 
        weight: params[:user][:weight],
        wrist: params[:user][:wrist], 
        waist: params[:user][:waist],  
        forearm: params[:user][:forearm],
        height: params[:user][:height],
        neck: params[:user][:neck],
        hips: params[:user][:hips],
        chest: params[:user][:chest],
        body_fat: @user.body_fat,
        user_id: @user.id)

      if @user.save && measurement.save
        # need to save data before we can calculate body fat
        session[:user_id] = @user.id
        # @user.body_fat = find_body_fat
        redirect_to @user
      else
        redirect_to new_user_path
      end
    else
      redirect_to new_user_path
    end
  end

  def edit
      @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])

    measurement = Measurement.new( 
      weight: params[:user][:weight],
      wrist: params[:user][:wrist], 
      waist: params[:user][:waist],  
      forearm: params[:user][:forearm],
      height: params[:user][:height],
      neck: params[:user][:neck],
      hips: params[:user][:hips],
      chest: params[:user][:chest],
      body_fat: find_body_fat,
      user_id: @user.id)

    if @user.update(user_params) && measurement.save
      flash[:success] = "User successfully updated!"
      if current_user.admin?
        redirect_to users_path
      else
        redirect_to user_path
      end
    else
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    client = User.find_by(id: params[:id])
    if current_user.admin?
      if client.destroy
        flash[:success] = "User successfully deleted!"
        redirect_to users_path
      else
        redirect_to users_path
      end
    else
      redirect_to root_path
    end
  end

  private
  

  def user_params
    params.require(:user).permit(
      :first_name, 
      :last_name, 
      :email, 
      :password, 
      :password_confirmation, 
      :avatar, 
      :age, 
      :gender, 
      :weight,
      :age,
      :waist,
      :height,
      :body_fat,
      :neck,
      :forearm,
      :hips,
      :chest,
      :wrist)
  end

  def phases(user)
    phase_collection = []
    user.workouts.each do |workout|
      phase_collection.push(workout.phase)
      phase_collection = phase_collection.uniq
    end
    return phase_collection
  end

  # copied over from measurements controller
  def user_age
    user = User.find_by(id: params[:id])
    return user.age
  end

  def user_waist
    user = User.find_by(id: params[:id])
    return user.waist
  end

  def user_wrist
    user = User.find_by(id: params[:id])
    return user.wrist
  end

  def user_forearm
    user = User.find_by(id: params[:id])
    return user.forearm
  end

  def user_weight
    user = User.find_by(id: params[:id])
    return user.weight
  end

  def user_height
    user = User.find_by(id: params[:id])
    return user.height
  end

  def user_neck
    user = User.find_by(id: params[:id])
    return user.neck
  end

  def user_hips
    user = User.find_by(id: params[:id])
    return user.hips
  end

  def user_chest
    user = User.find_by(id: params[:id])
    return user.chest
  end

  def user_body_fat
    user = User.find_by(id: params[:id])
    return user.body_fat
  end

  def user_id
    user = User.find_by(id: params[:id])
    return user.id
  end

  def user_gender
    user = User.find_by(id: params[:id])
    return user.gender
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


  def user_height
    user = User.find_by(id: params[:id])
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
