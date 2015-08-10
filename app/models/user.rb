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
    # array return:
    #   [
    #     flash_key -> :notice if user can login
    #               -> :error otherwise
    #     message   -> "Bem vindo..." if can login
    #               -> "Usuario ou senha invalida." if user or pass is invalid
    #               -> "Usuario ou senha invalida. Restam..." & failed_attempts < attempts
    #               -> "Usuario .. bloqueado" if failed_attempts >= attempts
    #   ]
    message = "Usuário ou senha inválida."
    result = [:error, message]
    return result if email.nil? || (email.nil? && password.nil?)
    if (user = find_by_email(email))
      failed_attempts = user.failed_attempts
      attempts        = user.attempts
      if failed_attempts >= attempts
        result = [:error, "Usuário #{user.email} bloqueado!"]
      else
        if user.password == password
          result = [:notice, "Bem vindo #{user.email}!"]
          user.update failed_attempts: 0
        else
          result = [:error, "#{message} Restam #{failed_attempts + 1}/#{attempts} tentativas"]
          user.update failed_attempts: user.failed_attempts + 1
        end
      end
    end
    return result
  end

end
