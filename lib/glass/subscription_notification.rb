module Glass
  class SubscriptionNotification
    attr_accessor :google_account,    :params,                  :collection,
                  :user_actions,      :reply_request_hash,      :glass_item_id

    class VerificationError < StandardError; end

    def self.create(params)
      notification = new(params)
      notification.handle!
    end
    def initialize(params)
      self.params = params
      self.collection = params[:collection]
      self.user_actions = params[:userActions]
      self.google_account = find_google_account(params)
      verify_authenticity!
    end


    ## things required to handle the notification properly
    ##
    ## 1. depending on the type of notification, we're going
    ##    to need to get access to a timeline item


    ## Perform the corresponding notification actions
    def handle!
      if collection == "locations"
        handle_location
      else
        self.glass_item_id = params[:itemId]
        handle_reply(params)
        handle_action
      end
    end

    private
    def handle_location
      google_client = ::Glass::Client.new(google_account: self.google_account)
      google_account.update_location(google_client.get_location)
    end

    def handle_reply(params)
      return unless has_user_action? :reply
      google_client = ::Glass::Client.new(google_account: self.google_account)
      self.reply_request_hash = google_client.get_timeline_item(params[:itemId])
      self.glass_item_id = reply_request_hash[:inReplyTo]
    end


    def has_user_action?(action)
      user_actions.select{|user_action| user_action["type"].downcase == action.to_s}.first
    end

    ## Handle actions on a timeline_item with a given id (custom actions, delete, etc.)
    def handle_action
      timeline_item = find_timeline_item(self.glass_item_id)

      # TODO: Should we uniq these? When glass doesn't have connection, it will queue up
      # actions, so users might press the same one multiple times.
      user_actions.uniq.each do |user_action|
        type = user_action[:type] == "CUSTOM" ? user_action[:payload] : user_action[:type]
        json_to_return = self.reply_request_hash ? self.reply_request_hash : self.params
        timeline_item.send("handles_#{type.downcase}", json_to_return)
      end if user_actions
    end

    ## Find the associated user from userToken
    def find_google_account(params)
      GoogleAccount.find params[:userToken]
    end

    ## Find a given timeline item owned by the user
    def find_timeline_item(item_id)
      Glass::TimelineItem.find_by_glass_item_id_and_google_account_id(item_id, google_account.id)
    end

    ## Verify authenticity of callback before doing anything
    def verify_authenticity!
      unless params[:verifyToken] == google_account.verification_secret
        raise VerificationError.new("received: #{params[:verifyToken]}")
      end
    end
  end
end
