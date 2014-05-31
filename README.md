# Radriar

A set of opinionated API design helpers for Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'radriar'

## Includes

* [representable](https://github.com/apotonick/representable)
* [roar](https://github.com/apotonick/roar)
* [grape](https://github.com/intridea/grape)

## Features

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

Assuming you're using the right conventions (to be redacted) this will magically
turn your API from this:

```javascript
{
    "id": "blackxored",
    "first_name": "Adrian",
    "last_name": "Perez",
    "hireable": false,
    "avatar_url": "https://secure.gravatar.com/avatar/0c21d966c02665709ebff791484c09e9?s=32&d=http://skindler.com/images/default-avatar.png",
    "registered_at": "2013-06-18T06:37:39.248Z",
    "social_urls": {
        "github": "https://github.com/blackxored",
        "twitter": "https://twitter.com/blackxored"
    },
    "username": "blackxored"
}
```

To this:

```javascript
{
    "_links": {
        "html": {
            "href": "/#/u/blackxored"
        },
        "self": {
            "href": "/users/blackxored"
        },
        "timeline": {
            "href": "/users/blackxored/timeline"
        }
    },
    "id": "blackxored",
    "firstName": "Adrian",
    "lastName": "Perez",
    "avatarUrl": "https://secure.gravatar.com/avatar/0c21d966c02665709ebff791484c09e9?s=32&d=http://skindler.com/images/default-avatar.png",
    "hireable": false,
    "registeredAt": "2013-06-18T06:37:39.248Z",
    "socialUrls": {
        "github": "https://github.com/blackxored",
        "twitter": "https://twitter.com/blackxored"
    },
}

## Contributing

1. Fork it ( https://github.com/[my-github-username]/radriar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
