# == Schema Information
#
# Table name: customer_profiles
#
#  id                  :integer          not null, primary key
#  customer_id         :integer          not null
#  name                :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#

class CustomerProfile < ActiveRecord::Base
  belongs_to :customer

  # Validates
  # --------------------------
  validates :name, :presence => true  
end
