class Site::UsersController < Site::ApplicationController

  before_filter :authenticate_user!, only: [:my_videos]

  def my_videos
    @videos = current_user.videos.exists.published.order(:created_at)
  end

end