# Glass::Rails

This is not at all stable yet.

## Installation

Add this line to your application's Gemfile:

    gem 'glass-rails'

And then execute:

    $ bundle

Or install locally by running the following command:

    $ gem install glass-rails

## Usage

### Setting up

We have a rails generator which will generate a 
yaml file for your google api keys. The command for 
the generator is: 

    rails g glass:install

This will generate a yaml file for your keys, an initializer for 
setting up configuration details, and migrations for the appropriate
tables.

### Templates

This gem includes a template generator, which provides a basic 
set of default templates (derived directly from the recommended templates 
which are shown in the glass playground). 

To generate the default templates, you can run the command:

    rails g glass:templates

This will generate a basic series of templates under the path,
`app/views/glass` though you may want to organize them more logically,
depending on your use case

### Glass Models

This gem also provides a glass model generator, which generates a timeline-item
model for your use:

For example, let's say you want to post a tweet to a user's glass timeline, 
you may want to have a glass model which represents tweets. To generate that
model, you can run this command: 

    rails g glass:model tweet

and you will find a model generated for you in the directory,
`app/models/glass/<glassmodelname>.rb`. 

It is primarly with Glass Models that you generate your glass application,
so understanding the mechanisms by which we map out over the actual google
api is probably a good idea. 

If you want your timeline item to have a list of menu-items, you can specify 
the menu-items in your glass model like so:

```ruby
 class Glass::Tweet < Glass::TimelineItem
    has_menu_item :custom_action_name, 
                  display_name: "this is displayed", 
                  icon_url: "http://icons.iconarchive.com/icons/enhancedlabs/lha-objects/128/Filetype-URL-icon.png", 
                  with: :custom_action_handler
 end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
