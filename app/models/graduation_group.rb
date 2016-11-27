# == Schema Information
#
# Table name: graduation_groups
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  name_noaccent :string(255)
#  url_friendly  :string(255)
#  active        :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  views         :integer
#  json_data     :text
#  description   :text
#  source        :string(255)
#

class GraduationGroup < ActiveRecord::Base
  include Shared::Methods

  include PgSearch
  pg_search_scope :search,
    :against => [:name_noaccent],
    :using => { tsearch: { :prefix => true } }

  has_many :graduations
  has_many :videos,           through: :graduations
  has_many :institutions,     through: :graduations
  has_many :ufs,              through: :institutions
  has_many :cities,           through: :institutions
  has_many :method_teachings, through: :graduations
  has_many :evaluation_graduations


  # Validates
  # --------------------------
  validates :name, :presence => true
  

  # Callbacks
  # --------------------------
  before_save :generate_url_friendly
   

  # generate_url_friendly
  # --------------------------
  def generate_url_friendly
    self.name_noaccent = I18n.transliterate(self.name).humanize
    self.url_friendly  = self.name_noaccent.parameterize
  end


  # Naive approach
  # --------------------------
  def self.rebuild_pg_search_documents
    PgSearch::Document.delete_all(:searchable_type => GraduationGroup.name)
    GraduationGroup.all.each do |record| record.save! end    
  end

  def update_json_data
    total_professional = self.videos.exists.published.professional.count
    total_universitary = self.videos.exists.published.universitary.count
    total_videos       = total_professional + total_universitary

    json_data = {
      :videos => {
        :total => {
          :all => total_videos,
          :professional => total_professional,
          :universitary => total_universitary
        }
      }
    }.to_json

    self.json_data = json_data
  end

  def keywords_graduations
    self.graduations.all.map(&:name).join(',')
  end

  def keywords_institutions
    self.ufs.distinct.map(&:name).join(',')
  end

end
