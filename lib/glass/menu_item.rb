module Glass
  class MenuItem
    attr_accessor :action,        :id,                    :display_name, 
                  :icon_url,      :remove_when_selected

                  
    BUILT_IN_ACTIONS = [:reply,         :reply_all,       :delete, 
                        :share,         :read_aloud,      :voice_call, 
                        :navigate,      :toggle_pinned]


    def self.create(action_sym, args)
      args = BUILT_IN_ACTIONS.include?(action_sym) ? args.merge({action: action_sym.to_s.upcase}) : args.merge({id: action_sym})
      new(args)
    end

    def initialize(opts={})
      self.action                 = opts[:action] || "CUSTOM"
      self.id                     = opts[:id]
      self.display_name           = opts[:display_name]
      self.icon_url               = opts[:icon_url]
      self.remove_when_selected   = opts[:remove_when_selected] || false
    end

    def action
      @action ||= "CUSTOM"
    end

    def serialize
      hash = {action: action}
      hash.merge!({id: id,
                   removeWhenSelected: remove_when_selected,
                   values: [{ displayName: display_name, 
                              iconUrl: icon_url}]}) if action == "CUSTOM"
      hash
    end
  end
end