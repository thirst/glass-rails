require "glass_rails"
require 'spec_helper'

describe "HanDleBars" do 
  context "HTML" do 
    before :each do 
      class TimelineObject; attr_accessor :footer;end;
      t=TimelineObject.new
      @template = Glass::HanDleBars::Html.new(t)
    end
    it "should not convert to an empty string on to_s" do 
      @template.to_s.should_not eq("")
    end
    
  end

end