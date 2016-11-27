# == Schema Information
#
# Table name: customers
#
#  id                     :integer          not null, primary key
#  role                   :string(100)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  status                 :boolean
#  created_at             :datetime
#  updated_at             :datetime
#  deleted_at             :datetime
#

class Customer < ActiveRecord::Base
  extend Enumerize

  # Relationships
  # -------------
  has_one :profile, :class_name => "CustomerProfile", :dependent => :delete
  has_many :institutions

  # Enumerize
  # --------------------------  
  enumerize :role,   in: [ :manager ], predicates: true
  enumerize :status, :in => { active: true, blocked: false }, predicates: true, default: :active

  # Nested
  # --------------------------
  accepts_nested_attributes_for :profile, update_only: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :confirmable

  def devise_mailer
    CustomerMailer
  end

  def attempt_set_password(params)
    update_attributes({ :password => params[:password], :password_confirmation => params[:password_confirmation] })
  end

  def has_no_password?
    self.encrypted_password.blank?
  end

  def only_if_unconfirmed
    pending_any_confirmation{ yield }
  end

  def password_required?
    return false unless persisted?
    !password.nil? || !password_confirmation.nil?
  end

  def password_match?
    self.password == self.password_confirmation
  end

  def save_institutions(institutions)
    institutions.uniq.each do |institution|
      institution = Institution.find(institution.to_i)
      if institution.customer.nil?
        institution.customer_id = self.id
        institution.save!
      end
    end
  end

end
