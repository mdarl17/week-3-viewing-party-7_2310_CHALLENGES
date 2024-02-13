class User <ApplicationRecord 
  validates_presence_of :email, :name, :password_digest, :password_confirmation
  validates_uniqueness_of :email
  has_many :viewing_parties
end 