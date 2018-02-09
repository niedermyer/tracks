class User < ApplicationRecord

  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :lockable

  validates :first_name,
            :last_name,
            presence: true
end