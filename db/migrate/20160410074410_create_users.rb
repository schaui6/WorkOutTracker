class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :gender
      t.integer :age
      t.float :height
      t.float :weight
      t.float :waist
      t.float :wrist
      t.float :forearm
      t.float :body_fat
      t.float :neck
      t.float :chest
      t.float :hips
      t.boolean :admin, default: false

      t.timestamps null: false
    end
  end
end
