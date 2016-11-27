# == Schema Information
#
# Table name: user_profiles
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  name           :string(255)
#  birthday       :date
#  picture        :text
#  gender         :string(10)
#  fb_uid         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  school_id      :integer
#  scholarity     :integer
#  grade          :string(50)
#  enterprise_job :text
#  job_title      :text
#  semester       :integer
#  institution_id :integer
#  graduation_id  :integer
#  city           :string(255)
#  student_loan   :boolean
#

class UserProfile < ActiveRecord::Base
  
  belongs_to :user, :dependent => :delete
  belongs_to :institution

  # Validates
  # --------------------------
  validates :scholarity, :presence => { :message => "Por favor, selecione a sua escolaridade" }

end
