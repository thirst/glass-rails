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

### 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
