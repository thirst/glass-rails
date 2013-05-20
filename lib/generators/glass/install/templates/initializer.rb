if Rails.env.development?
  ##
  ## if you've set this elsewhere you may want 
  ## to comment this out. 
  ##
  ## Glass requires this to be defined for callback url 
  ## purposes.
  ##
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
elsif Rails.env.test?
  
  ## setup whatever you want for default url options for your test env.
end

Glass.setup do |config|
  ## you can override the logo here
  ## config.brandname = "examplename"



  ## manually override your glass views path here.
  config.glass_template_path = "app/views/glass"

end
