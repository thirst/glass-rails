module Glass
  class SubscriptionNotification
    attr_accessor :google_account,    :params,    :collection,
                  :user_actions

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

    ## Perform the corresponding notification actions
    def handle!
      if collection == "locations"
        # TODO: This is a location update - should the GoogleAccount handle these updates?
        # When your Glassware receives a location update, send a request to the glass.locations.get endpoint to retrieve the latest known location.
        # Something like: google_account.handle_location_update
      else
        if has_user_action? :share
          # TODO: Someone shared a card with this user's glassware. Who should handle this?
          # The actual reply with attachments with itemId, so we need to fetch that
          # Something like google_account.handle_shared_item(params)
        elsif has_user_action? :reply
          # TODO: Someone replied to a card.
          # itemId => TimelineItem which contains at least: inReplyTo (original item),
          # text (text transcription of reply), and attachments
        else # Custom Action or DELETE
          handle_action(params[:itemId])
        end
      end
    end

    private
    def has_user_action?(action)
      user_actions.select{|user_action| user_action["type"].downcase == action.to_s}.first
    end

    ## Handle actions on a timeline_item with a given id (custom actions, delete, etc.)
    def handle_action(item_id)
      timeline_item = find_timeline_item(item_id)

      # TODO: Should we uniq these? When glass doesn't have connection, it will queue up
      # actions, so users might press the same one multiple times.
      user_actions.uniq.each do |user_action|
        type = user_action[:type] == "CUSTOM" ? user_action[:payload] : user_action[:type]
        timeline_item.send("handles_#{type.downcase}")
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