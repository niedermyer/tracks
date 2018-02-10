class User < ApplicationRecord

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable

  validates :first_name,
            :last_name,
            presence: true

  before_save :set_public_id


  private


  def set_public_id
    return if self.public_id.present?
    self.public_id = generate_public_id
  end

  def generate_public_id
    loop do
      random_id = SecureRandom.hex(6)
      break random_id unless User.exists?(public_id: random_id)
    end
  end
end