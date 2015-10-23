class User < ActiveRecord::Base

  before_save do
    self.email = email.downcase
    white_space_regex = /\s+/
    name_array = name.split(white_space_regex)
    name_array.map! do |n|
      n.capitalize
    end
    self.name = name_array.join(" ")
  end
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, length: {minimum: 1, maximum: 1000}, presence: true

  validates :password, presence: true, length: {minimum: 6}, if: "password_digest.nil?"
  validates :password, length: {minimum: 6}, allow_blank: true

  validates :email,
            presence: true,
            uniqueness: {case_sensitive: false},
            length: {minimum: 3, maximum: 100},
            format: {with: EMAIL_REGEX}

  has_secure_password
end
