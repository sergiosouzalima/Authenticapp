class User < ActiveRecord::Base
  validates :email,    presence: true, uniqueness: true
  validates :email,    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { in: 6..20 }, confirmation: true
  before_create :default_values
  def default_values
    self.attempts = 5
    self.failed_attempts = 0
  end

  def self.authenticate(email, password)
    return nil if email.nil? || password.nil?
    user = nil
    if ( user = find_by_email(email) )
      if user.password == password
        user.update failed_attempts: 0
      else
        user.update failed_attempts: user.failed_attempts + 1
      end
    end
    return user
  end

end
