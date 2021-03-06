class User < ApplicationRecord

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable,
         :invitable

  has_many :tracks

  validates :first_name,
            :last_name,
            presence: true

  before_save :set_public_id
  after_invitation_accepted :notify_inviter

  def full_name
    "#{first_name} #{last_name}".squish
  end

  def processing_email
    "#{public_id}@#{EmailProcessor::PROCESSING_HOSTNAME}"
  end

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

  def notify_inviter
    UserMailer.invitation_accepted(self).deliver_now
  end
end