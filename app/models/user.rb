class User < ActiveRecord::Base

  has_secure_password

  has_many :workouts

  has_many :progresses
  has_many :measurements

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  has_attached_file :avatar, styles: { large: "600x600>", medium: "300x300>", thumb: "150x150#" }, default_url: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRbb0oF8-z4-eCchws0dlDefeVEiyth295cu4vmj-N2d5Eq9b9zVA"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  before_save :downcase_fields

   def downcase_fields
      self.email.downcase!
   end


end
