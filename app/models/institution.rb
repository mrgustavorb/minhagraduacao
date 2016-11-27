# == Schema Information
#
# Table name: institutions
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  co_ies                   :integer
#  co_mantenedora           :integer
#  active                   :boolean
#  load_code                :string(100)
#  no_ies                   :string(200)
#  name_noaccent            :string(200)
#  url_friendly             :string(200)
#  sigla                    :string(100)
#  uf_id                    :integer
#  customer_id              :integer
#  academic_organization_id :integer
#  views                    :integer          default(0)
#

class Institution < ActiveRecord::Base

  include PgSearch
  pg_search_scope :search, :against => [:name_noaccent, :sigla], :using => { tsearch: { :prefix => true } }

  extend Enumerize

  # enumerize :academic_organization_id, in: [1 :universidade , centro_universitario: 2, faculdade: 3, instituto_federal: 4, centro_federal: 5]

  # Relationships
  # -------------
  belongs_to :customer
  belongs_to :uf
  belongs_to :academic_organization

  has_one  :profile, class_name: "InstitutionProfile"

  has_many :institution_photos 
  has_many :evaluation_institutions
  has_many :users
  has_many :user_profiles

  has_and_belongs_to_many :cities
   
  has_many :graduations_institutions
  has_many :graduations, -> { select 'graduations.*, graduations_institutions.id as graduation_institution_id' }, :through => :graduations_institutions
  has_many :graduation_groups, :through => :graduations

  # using scopes
  scope :evaluation_graduations, -> { joins(:evaluation_institutions).where(user_profiles: {scholarity: 1}) }

  # Nested
  # --------------------------
  accepts_nested_attributes_for :profile, update_only: true

  def self.search_ufs(graduation_group_id)
    GraduationGroup.select('ufs.id, ufs.name')
                   .distinct
                   .joins(:ufs)
                   .where(graduation_groups: {id: graduation_group_id}, graduations_institutions: {method_teaching_id: 1})
                   .order("ufs.name ASC")                       
  end

end
