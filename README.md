# Glass::Rails

A DSL for building Google Glass apps using Ruby on Rails.

## Installation

Add this line to your application's Gemfile:

    gem "google-api-client" # this is a dependency
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

### Glass Models - (Introduction)

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
                  handles_with: :custom_action_handler
 end
```
### Glass Models - Menu Items

You can define a series of menu items for a glass model,
using the helper method `has_menu_item`. This method takes the 
following arguments:

```ruby
class Glass::ExampleCard < Glass::TimelineItem
  has_menu_item <symbolized_name_of_action>, <options>
  ## here options is a hash, and you can define here:
  ## the displayed name of the action/menu item, 
  ## i.e. 'like', as well as a url for an icon, and 
  ## a callback method which gets executed when you
  ## are notified of an event.
end
```

Basically, the way that the google mirror api works, you
are required to subscribe to notifications from a user to
get updated on the status of a user action on a timeline 
item. This gems aims to aid the subscription and notification 
process, primarily to get the process bootstrapped and ready to
go. 

You will automatically be subscribed to notifications on a timeline
item, and will get notified to your glass callback url, which we have 
inserted into your routes for you if you have used the install 
generator.

Once you have generated a timeline item glass model:

```ruby
class Glass::Tweet < Glass::TimelineItem
end
```

You can use the `has_menu_item` helper method in your
glass model to define menu items. These menu items will them be
applied uniformly for your entire class. 

Once you've posted to the timeline item to the glass user's
timeline, you are registered to listen for notifications 
that the user has acted on your card. You can specify a callback method
using the `has_menu_item` helper method, by passing in the



### Glass Models - (Posting Content) 

So using our Glass::Tweet class which we created above, we
could instantiate a new instance of the class and assign it 
an associated google account like so

```ruby
gt = Glass::Tweet.new(google_account_id: GoogleAccount.first)
```
Then, you can populate an erb template with instance variables by
using the `serialize` method which is available to all subclasses 
of Glass::TimelineItem (and yeah, to be clear, this includes Glass::Tweet).
For example, let's say you have the following erb template:

```erb
<article>
  <h1><%= @title %></h1>
  <section>
    <ul>
      <%= @content %>
    </ul>
  </section>
</article>
```

You can serialize the template for a glass::tweet instance like so:

```ruby
gt = Glass::Tweet.new(google_account_id: GoogleAccount.first)
gt.serialize({template_variables: {content: "asdfasdfasdf", title: "title"}})
```

which will basically populate the `@content` and `@title` instance variables
in the erb template, render it as a string, and get it prepped to send to the
mirror api for insertion into the timeline.

Then all you have to do is use the following command to actually insert the content:

```ruby
gt.client.insert
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
