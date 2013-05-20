require "glass"
require "glass/template"
describe "Glass::Template" do 
  context "HTML" do 
    before :each do 
      @template = Glass::Template.new
    end
    it "should not convert to an empty string on to_s" do 
      @template.render(@template.template_name).should eq("")
    end
    
  end

end