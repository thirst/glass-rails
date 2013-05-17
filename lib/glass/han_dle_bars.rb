module Glass
  class HanDleBars
    attr_accessor :timeline_item, :template
    def initialize(timeline_item)
      self.timeline_item = timeline_item
      timeline_item.footer = wrap_footer(timeline_item.footer)
      self.template = File.read("#{template_directory}/#{self.template_name}.han-dlebars")
      until there_is_a_partial(self.template) == false
        insert_partials
      end
      insert_content_and_footer
    end
    def glass_height
      360
    end
    def glass_width
      640
    end
    def template_directory
      if ::Glass.han_dle_bars_directory.present? 
        ::Glass.han_dle_bars_directory 
      else 
        path = File.expand_path File.dirname(__FILE__)
        "#{path}/templates"
      end
    end
    def to_s
      self.template
    end
    def there_is_a_partial(text)
       match_partial_template_in_template(text) ? true : false
    end
    def match_partial_template_in_template(text)
      /\{{2}partial\s(?<partial_name>[^}]+)\}{2}/.match(text)
    end
    def insert_partials
      matching_area = match_partial_template_in_template(self.template)
      partial_filename = matching_area[:partial_name]
      partial = File.read("#{template_directory}/_#{partial_filename}.han-dlebars")
      self.template.gsub!(/\{{2}partial\s#{partial_filename}\}{2}/, partial)
    end
    def template_name
      raise NoTemplateDefinedError
    end
    def style(options={})
      options.each do |html_type_option, html_attributes|
        option_type = "#{html_type_option}_options"
        html_attributes_list = ""
        html_attributes.each {|html_attribute, value| html_attributes_list += " #{html_attribute}='#{value}'"}
        self.template = template.gsub(/\s*\{{2}#{option_type}\}{2}/, html_attributes_list)
      end
      remove_unneeded_options!
    end
    def insertables
      raise InsertablesNotYetDefined
    end
    def insert_content_and_footer
      insertables.each do |template_content| 
        if timeline_item.respond_to?(template_content.to_sym)
          self.template = template.gsub(/\s*\{{2}#{template_content}\}{2}\s*/, timeline_item.send(template_content)) 
        end
      end
    end
    def remove_unneeded_options!
      self.template = template.gsub(/\s*\{{2}[^}]*_options\}{2}/, "")
    end
    def logo
      "<img src='https://dl.dropboxusercontent.com/u/13728536/droplet-icon.svg' style='height:15px;'/>"
    end
    private
    def wrap_footer(footer_content)
      footer_content.present? ? "<footer class='text-minor muted'>#{footer_content}</footer>" : ""
    end
  end
end