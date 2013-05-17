module Glass
  class HanDleBars::Html < HanDleBars
    def template_name
      "simple_html"
    end
    def insertables
      ["content", "footer"]
    end
  end
end