class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float :weight
      t.float :wrist
      t.float :forearm
      t.float :height
      t.float :neck
      t.float :waist
      t.float :left_arm
      t.float :right_arm
      t.float :hips
      t.float :chest
      t.float :right_thigh
      t.float :left_thigh
      t.float :body_fat
      t.float :dead_lift
      t.float :bench_press
      t.float :squat
      t.float :lat_pull
      t.integer :user_id


      t.attachment :photo

      t.timestamps null: false
    end
  end
end
