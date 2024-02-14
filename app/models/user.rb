class User < ApplicationRecord 
  validates_presence_of :email, :name, :password, :password_confirmation
  validates_uniqueness_of :email, case_sensitive: false
  has_many :viewing_parties
  
  has_secure_password
end
