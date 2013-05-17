module Glass
  class HanDleBars::SmallImage < HanDleBars
    def initialize(timeline_item)
      super(timeline_item)
      self.template.gsub!(style_small_image, self.image_style)
    end
    def image_top
      (self.glass_height - self.scaled_height) / 3.to_f
    end
    def scaled_height
      self.timeline_item.image_height * self.image_ratio
    end
    def third_of_glass_width
      self.glass_width / 3.to_f
    end
    def image_ratio
       third_of_glass_width / self.timeline_item.image_width
    end
    def image_style
      "style='position:absolute;left:0;top:#{image_top.to_i}px;max-width:100%;'"
    end

    def style_small_image
      /\{{2}small_image_style\}{2}/
    end
    def template_name
      "image_left_with_section_right"
    end
    def insertables
      ["content", "footer", "image_url"]
    end
  end
end