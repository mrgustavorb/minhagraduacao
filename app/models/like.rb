class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  scope :positive, -> { where(value: true)}
  scope :negative, -> { where(value: false) }
end
