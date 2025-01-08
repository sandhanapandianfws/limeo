class User < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true

  attr_accessor :password
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  enum usertype: { Admin: 0, User: 1, Author: 2 }


  has_many :course_subscriptions, dependent: :destroy
  has_many :courses, through: :course_subscriptions

  # Callbacks - Starts Here
  before_create :generate_email_verification_code

  before_save :encrypt_password
  # Callbacks - Ends Here

  def authenticate_password(password)
    BCrypt::Password.new(self.password_digest) == password
  end

  private
  def generate_email_verification_code
    self.email_verification_code = SecureRandom.uuid
    self.expiry_date = (DateTime.current.in_time_zone + 30.minutes).in_time_zone
  end


  private
  def encrypt_password
    if password.present?
      self.password_digest = BCrypt::Password.create(password)
    end
  end

end
