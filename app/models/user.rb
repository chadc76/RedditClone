# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#
class User < ApplicationRecord
  extend FriendlyId

  attr_reader :password
  
  friendly_id :username, use: :slugged

  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: { message: 'Password can\'t be blank' }
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :subs, dependent: :destroy, foreign_key: :moderator_id
  has_many :posts, dependent: :destroy, foreign_key: :author_id
  has_many :comments, dependent: :destroy, foreign_key: :author_id
  has_many :subscription_sets, dependent: :destroy, class_name: :Subscription
  has_many :subscriptions, through: :subscription_sets, source: :sub

  def self.find_by_credentials(user, pw)
    user = User.find_by(username: user)
    return nil if user.nil?
    user.is_password?(pw) ? user : nil 
  end

  def self.generate_token
    SecureRandom.urlsafe_base64(16)
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def reset_session_token!
    self.session_token = self.class.generate_token
    self.save
    self.session_token
  end

  def all_subs
    {my_subs: self.subs, subscriptions: self.subscriptions}
  end

  def post_score
    posts
      .map(&:hotness)
      .sum
  end

  def comment_score
    comments
      .map(&:hotness)
      .sum
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_token
  end
end
