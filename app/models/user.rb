class User < ApplicationRecord
  validates_presence_of :name, allow_nil: false
  validates_presence_of :email, allow_nil: false, case_sensitive: false
  validates_uniqueness_of :email
  validates_presence_of :password_digest, allow_nil: false
  validates_presence_of :password_confirmation, allow_nil: false
  validates_presence_of :password, allow_nil: false
  has_many :viewing_parties
  
  has_secure_password

  str = ""

  def authorized(params)
    return true if self.authenticate(params[:password])
    false
  end

  def persist(data)
    str = data
  end
end
