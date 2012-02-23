# Sagamore Client

This is the Sagamore Client library for Ruby. It provides access to the Sagamore HTTP API.

It is a wrapper around the [Patron](http://toland.github.com/patron/) HTTP client library.

## Examples

### Connecting
```ruby
client = Sagamore::Client.new 'http://example.sagamore.us',
  :username => 'user',
  :password => 'secret'
```

### Resource oriented
```ruby
resource = client[:items][1234]
response = resource.get
```

### URI oriented
```ruby
response = client.get '/items/1234'
```
