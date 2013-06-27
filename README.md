# Pluct

WIP

## Installation

Add this line to your application's Gemfile:

    gem 'pluct'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pluct

## Usage

```ruby
require 'pluct'
apps = Pluct::Resource.new('http://repos.backstage.globoi.com/')
app = apps.collection({context_name: 'test-baas', collection_name: 'apps'}).add({name: 'Minha nova app.', description: 'App description.'})

p app.response.headers[:location]
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
