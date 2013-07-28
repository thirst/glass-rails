## if you've set this elsewhere you may want 
## to comment this out. 
##
## Glass requires this to be defined for callback url 
## purposes.

Rails.application.routes.default_url_options[:host] = 'localhost:3000' if Rails.env.development?

## Your configuration details here:

Glass.setup do |config|
  ## modify this to change the name of your glass app
  ## config.application_name = "SomeGlassApp"

  ## modify this to change the application version of your glass app
  ## config.application_version = "0.0.1"


  ## manually override your glass views path here.
  config.glass_template_path = "app/views/glass"
end
