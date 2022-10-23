class User < ApplicationRecord
  has_secure_password

  def welcome
    "Hello, #{self.first_name}!"
  end
end