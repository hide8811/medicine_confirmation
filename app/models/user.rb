class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :employee_id, presence: true, uniqueness: { case_sensitive: true }
  validates :encrypted_password, presence: true, length: { in: 8..16 }, format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]{8,16}+\z/ }
  validates :last_name, :first_name, presence: true
  validates :last_name_kana, :first_name_kana, presence: true, format: { with: /\A[ぁ-んー－]+\z/ }
end
