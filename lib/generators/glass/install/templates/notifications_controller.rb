class Glass::NotificationsController < ApplicationController
  def callback
    glass_notification = Glass::Notification.new(params)
    glass_notification.handle!
    render json: {success: true}
  end
end