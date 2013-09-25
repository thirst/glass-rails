module Glass
  class MenuItem
    attr_accessor :action,        :id,                    :display_name,
                  :icon_url,      :remove_when_selected,
                  :pending_name,  :confirmed_name,
                  :pending_icon_url, :confirmed_icon_url

 
    BUILT_IN_ACTIONS = [:reply,         :reply_all,       :delete,
                        :share,         :read_aloud,      :voice_call,
                        :navigate,      :toggle_pinned,   :open_uri,
                        :play_video]


    def self.create(action_sym, args)
      args = BUILT_IN_ACTIONS.include?(action_sym) ? args.merge({action: action_sym.to_s.upcase}) : args.merge({id: action_sym})
      new(args)
    end

    def initialize(opts={})
      self.action                 = opts[:action] || "CUSTOM"
      self.id                     = opts[:id]
      self.display_name           = opts[:display_name]
      self.pending_name           = opts[:pending_name]
      self.confirmed_name         = opts[:confirmed_name]
      self.icon_url               = opts[:icon_url]
      self.pending_icon_url       = opts[:pending_icon_url]
      self.confirmed_icon_url     = opts[:confirmed_icon_url]
      self.remove_when_selected   = opts[:remove_when_selected] || false
    end

    def action
      @action ||= "CUSTOM"
    end

    def serialize
      hash = {action: action}
      values = [{displayName: display_name, iconUrl: icon_url, state: "DEFAULT"}]

      if self.pending_name
        values << {displayName: pending_name, iconUrl: pending_icon_url, state: "PENDING"}
      end
      if self.confirmed_name
        values << {displayName: confirmed_name, iconUrl: confirmed_icon_url, state: "CONFIRMED"}
      end

      hash.merge!({id: id,
                   removeWhenSelected: remove_when_selected,
                   values: values}) if action == "CUSTOM"
      hash
    end
  end
end
