# == Schema Information
#
# Table name: institution_profiles
#
#  id                         :integer          not null, primary key
#  institution_id             :integer
#  description                :text
#  igc                        :integer          default(0)
#  accepts_fies               :boolean          default(FALSE)
#  accepts_prouni             :boolean          default(FALSE)
#  total_professors_phd       :integer          default(0)
#  total_professors_master    :integer          default(0)
#  total_professors_graduatos :integer          default(0)
#  site                       :string(255)
#  video_link                 :string(255)
#  email                      :text
#  phone                      :string(255)
#  address                    :string(255)
#  url_facebook               :string(255)
#  url_twitter                :string(255)
#  url_youtube                :string(255)
#  url_instagram              :string(255)
#  url_google_plus            :string(255)
#  avatar_file_name           :string(255)
#  avatar_content_type        :string(255)
#  avatar_file_size           :integer
#  avatar_updated_at          :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  cep                        :string(50)
#

class InstitutionProfile < ActiveRecord::Base
  extend Enumerize

  # Relationships
  # -------------  
  belongs_to :institution

  # Paperclip
  # -------------
  has_attached_file :avatar, 
                    :styles => { :thumb => "380x190>" }, 
                    :path => '/:class/:id/:style/logo.:extension'  
  
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  #
  #=============================
  def avatar_url
    avatar.url(:thumb)
  end     
end
