module Glass
  class HanDleBars::FullImage < HanDleBars
    def template_name
      "image_full"
    end
    def insertables
      ["content", "footer", "image_url"]
    end
  end
end