class User < ActiveRecord::Base
  # attr_accessor :password, :password_confirmation

  has_many :posts, dependent: :destroy#, class_name: 'Post'
  has_many :comments, dependent: :destroy#, class_name: 'Comment', foreign_key: 'user_id'
  has_many :votes, dependent: :destroy#, class_name: 'Vote', foreign_key: 'user_id'
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, class_name: 'Post', foreign_key: 'post_id'
  # @user.posts
  # @user.favorited_posts

  before_save {self.email = email.downcase}
  before_save {self.role ||= :member}
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
  enum role: [:member, :admin]

  def favorite_for(post)
    favorites.where(post_id: post.id).first
  end

  def avatar_url(size)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def find_favorite_posts
    fav_array = self.favorites.map do |fav|
      Post.find(fav.post_id)
    end
  end



end
