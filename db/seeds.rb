def rand_workout
  ["Squats", "Jump Squats", "Push-Ups","Mtn Climbers","Frog Jumps","Sit-Ups"].sample
end

def rand_weight
  ('100'..'250').to_a.push('BW').sample
end


# Create 3 known users
eddy = User.create(first_name: "Eddy", last_name: "Trainer", email: "eddy@gmail.com", password: "password", admin: true, gender: "male", age: 33, height: 65.0, weight: 185.0, waist: 32.0, wrist: 7, forearm: 9.5, hips: 40.5, chest: 44, neck: 17, body_fat: 20)
jane = User.create(first_name: "Jane", last_name: "Client", email: "jane@gmail.com", password: "password", admin: false, gender: "female", age: 30, height: 60.0, weight: 105.0, waist: 23.0, wrist: 4, forearm: 4.5, hips: 20.5, chest: 20, neck: 7, body_fat: 20)
john = User.create(first_name: "John", last_name: "Client", email: "john@gmail.com", password: "password", admin: false, gender: "male", age: 33, height: 69.0, weight: 213.4, waist: 40.5, wrist: 7, forearm: 9.5, hips: 40.5, chest: 44, neck: 17, body_fat: 30)


# Create fake Users
# 30.times do #create 30 users
#   random_user = User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "password", admin: false)

#     #each user create 10 work out from phase 1- 4
    10.times do
      # random_user.workouts.create(name: rand_workout, reps: rand(7..10), sets: rand(2..3), weight: rand_workout, phase: rand(1..4), day: rand(1..4), rest: rand(0..3))
      jane.workouts.create(name: rand_workout, reps: rand(8..12), sets: rand(3..4), weight: rand_weight, phase: rand(1..4), day: rand(1..8), rest: rand(30..60))
      john.workouts.create(name: rand_workout, reps: rand(8..12), sets: rand(3..4), weight: rand_weight, phase: rand(1..4), day: rand(1..8), rest: rand(30..60))
    end

#     # Create 10 random measurements for random users
#     10.times do
#       random_user.measurements.create(weight: rand(90..200), body_fat: (6..20), dead_lift: rand(100..300), bench_press: rand(100..300), squat: rand(100..300), lat_pull: rand(100.300))
#     end

# end
