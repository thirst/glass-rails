module Glass
  class Notification
    attr_accessor :google_account, :params, :collection, :timeline_item, :user_actions

    class VerificationError < StandardError; end

    def initialize(params)
      self.params = params
      self.google_account = find_google_account(params)
      self.timeline_item = find_timeline_item
      self.collection = params[:collection]
      self.user_actions = params[:userActions]
      verify_authenticity!
    end

    def handle!
      user_actions.uniq.each do |user_action|
        type = user_action[:type] == "CUSTOM" ? user_action[:payload] : user_action[:type]
        timeline_item.send("handle_#{type.downcase}", params)
      end if user_actions
    end

    private
    def find_google_account(params)
      GoogleAccount.find params[:userToken]
    end
    def find_timeline_item
      if %w(UPDATE DELETE).include? params[:operation]
        Glass::TimelineItem.find_by_google_id_and_google_account_id(params[:itemId], google_account.id)
      else # INSERT - itemId is the id of the new item, which has a inReplyTo to an existing one
        external_account = user.external_accounts.where(type: :Google).first
        manager = GlassManager.new(external_account: external_account)
        item = manager.find(params[:itemId])
        params[:reply] = item
        Glass::TimelineItem.find_by_google_id_and_user_id(item[:inReplyTo], user.id)
      end
    end
    def verify_authenticity!
      ##some logic for verification of authenticity.
    end
  end
end