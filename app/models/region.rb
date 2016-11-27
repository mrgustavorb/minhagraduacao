# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string(100)
#  region     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Region < ActiveRecord::Base
  has_many :ufs
end
