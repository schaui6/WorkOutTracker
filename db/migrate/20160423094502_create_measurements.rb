class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :weight
      t.integer :height
      t.integer :neck
      t.integer :waist
      t.integer :left_arm
      t.integer :right_arm
      t.integer :hips
      t.integer :chest
      t.integer :right_thigh
      t.integer :left_thigh
      t.float :body_fat
      t.integer :dead_lift
      t.integer :bench_press
      t.integer :squat
      t.integer :lat_pull
      t.integer :user_id
      t.string :img_url

      t.timestamps null: false
    end
  end
end
