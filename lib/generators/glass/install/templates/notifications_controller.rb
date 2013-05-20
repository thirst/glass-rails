class Glass::NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def callback
    Glass::SubscriptionNotification.create(params)
    render json: {success: true}
  end
end