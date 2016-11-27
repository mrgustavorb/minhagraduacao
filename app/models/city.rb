# == Schema Information
#
# Table name: cities
#
#  id           :integer          not null, primary key
#  uf_id        :integer
#  co_municipio :integer
#  name         :string(100)
#  is_capital   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class City < ActiveRecord::Base
  belongs_to :uf  
  has_many :schools
  has_and_belongs_to_many :institutions
end
