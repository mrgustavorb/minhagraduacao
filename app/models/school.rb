# == Schema Information
#
# Table name: schools
#
#  id                      :integer          not null, primary key
#  uf_id                   :integer
#  city_id                 :integer
#  cod_entidade            :string(100)
#  no_entidade             :string(100)
#  cod_orgao_regional_inep :string(10)
#  dependencia_adm         :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class School < ActiveRecord::Base

  # Relationships
  # -------------  
  belongs_to :uf
  belongs_to :city

  has_many :evaluation_schools

end
