# == Schema Information
#
# Table name: favorite_institutions
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  institution_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class FavoriteInstitution < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :user
  belongs_to :institution

end
