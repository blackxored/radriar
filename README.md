# Radriar

A set of opinionated API design helpers for Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'radriar'

## Conventions and included components

* API based on [Grape](https://github.com/intridea/grape)
* Model representation with [representable](https://github.com/apotonick/representable)
* Use of the `represent` and `represent_each` helpers inside the API, or a Grape formatter
  _(coming soon)_.
* Hypermedia features are based on [HAL](http://stateless.co/hal_specification.html) and
require [Roar](https://github.com/apotonick/roar).

## Key Features

__TODO__: Redact

* Key translation (Snake case to underscore and viceversa).
* Optional field includes (Pass `fields` parameter in URL).
* Conventional error responses.
* Optional inclusion/exclusion of hypermedia (HAL).

## Usage

Include the gem in your Gemfile:

```ruby
gem 'radriar'
```

Then radriarize your API ;), aka invoke the `#radriarize` method with the specified
options from your API definition.

``` ruby
class UserAPI < Grape::API
  radriarize representer_namespace: 'MyApp::Representers',
             hypermedia: true,
             translate_keys: true
```

### Dynamic APIs

Assuming you're using the right conventions (to be redacted) this will magically
turn your API from this:

```javascript
{
  "id": "blackxored",
  "first_name": "Adrian",
  "last_name": "Perez",
  "avatar_url": "...",
  "hireable": false,
  "registered_at": "...",
  "social_urls": {
    "github":  "https://github.com/blackxored",
      "twitter": "https://twitter.com/blackxored"
    },
  "comments": [ /* ... */],
}
```

To this:

```javascript
{
  "_links": {
    "self": {
      "href": "/users/blackxored"
    },
    "html": {
      "href": "/#/u/blackxored"
    },
    "timeline": {
      "href": "/users/blackxored/timeline"
    },
  },
  "_embedded": {
    "total": 2,
    "comments": [ /* ... */ ]
  },
  "id": "blackxored",
  "firstName": "Adrian",
  "lastName": "Perez",
  "avatarUrl": "...",
  "hireable": false,
  "registeredAt": "2013-06-18T06:37:39.248Z",
  "socialUrls": {
    "github":  "https://github.com/blackxored",
    "twitter": "https://twitter.com/blackxored"
  },
}
```

### Partial Responses

You can request partial responses (ideal for mobile apps). Just hit any endpoint with an optional `fields` attribute.

(__TODO__: Check that key translation works at the partial response level)

From the response above:

```shell
curl $URL?fields=id,firstName,avatarUrl
```

Will return the following JSON document:

```javascript
{
  "id": "blackxored"
  "firstName": "Adrian",
  "avatarUrl": "..."
}
```

### Error Conventions

__TODO__: Redact

### Pagination

__TODO__: Test and implement

All your collection get automated pagination by default. In the case of hypermedia APIs it also includes pagination links.

```javascript
{
    "_links": {
        "self":  "/collection?page=3",
        "first": "/collection",
        "next":  "/collection?page=4"
        "prev":  "/collection?page=2",
        "last":  "/collection?page=10"
    },
    "_embedded": {
      "collection": [ /*...*/]
    },
    "total": 250,
    "per": 25
}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/radriar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
