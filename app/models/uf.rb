# == Schema Information
#
# Table name: ufs
#
#  id         :integer          not null, primary key
#  sigla      :string(2)
#  name       :string(100)
#  created_at :datetime
#  updated_at :datetime
#  co_uf      :integer
#  region_id  :integer
#

class Uf < ActiveRecord::Base
  belongs_to :region
  has_many :institutions
  has_many :schools
  has_many :cities
end
