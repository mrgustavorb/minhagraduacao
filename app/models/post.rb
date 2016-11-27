# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  content      :text
#  url_friendly :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Post < ActiveRecord::Base
  belongs_to :employee
end
