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
end