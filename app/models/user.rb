# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmed_at           :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  provider               :string(255)
#  confirmation_token     :string(255)
#  confirmation_sent_at   :time
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  password_expires_at    :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  registration_ip        :string(15)
#  agree_use_term         :boolean
#  answered               :boolean          default(FALSE)
#  fake                   :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_one :user_profile
  has_one :evaluation_school
  has_one :evaluation_graduation
  has_one :evaliation_institution
  has_many :videos
  has_many :likes

  accepts_nested_attributes_for :user_profile


  # using scopes for define user's scholarity
  scope :students,      -> { joins(:user_profile).where(user_profiles: {scholarity: 1}) }
  scope :academics,     -> { joins(:user_profile).where(user_profiles: {scholarity: 2}) }
  scope :professionals, -> { joins(:user_profile).where(user_profiles: {scholarity: 3}) }
  
  scope :from_last_week, -> { where(last_sign_in_at: (DateTime.now - 7.days).utc.beginning_of_day..DateTime.now.utc.end_of_day) }
  scope :students_from_last_week, -> { students.merge(from_last_week) }
  scope :academics_from_last_week, -> { academics.merge(from_last_week) }
  scope :professionals_from_last_week, -> { professionals.merge(from_last_week) }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :confirmable, :lockable,
         :omniauthable, omniauth_providers: [:facebook]

  def devise_mailer
   UserMailer
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)

    profile = UserProfile.find_by_fb_uid(auth.uid)

    if profile
      user = profile.user
    else

      if auth.info.email.nil?
        return User.new
      end

      user = User.find_by_email auth.info.email
      if user.nil?
        user = User.new({
          email: auth.info.email,
          password: Devise.friendly_token[0,20],
          password_expires_at: Time.now
        })

        user.build_user_profile
        user.user_profile.name = auth.info.name
        user.user_profile.scholarity = 0
        user.user_profile.fb_uid = auth.uid

        user.skip_confirmation!
        user.save!
      end
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session["devise.facebook_data"])
        user.email = data.email if user.email.blank?
      end
    end
  end

  def after_password_reset
    self.update_attribute :password_expires_at, Time.now + 1.month
  end

 
end
