# TODO

## Now

* Choose a higher-level place to override for key translation.
* Paginate collections automatically
* Exposed actions as links
* Figure out whether to do key translation in links or not.
* Check if key translation works at the partial response level.

## Roadmap

* Use Grape reflection to:
  - Expose actions to generate API index.
  - Expose action parameters in links, such as this one:

  ```javascript
  {
    "addMember": {
      "href": "/repo/radriar/members",
      "method": "POST",
      "params": [
        { "member_id": { "type": "String", "required": true} }
      ]
    }
  }
  ```
  - Extract URL templates


* Support URI template URLs
  ```javascript
  {
    /* ... */
    "repos": {
      "href": "/repos{/id}",
      "templated": true
    },
  }
  ```

* Transparently convert Representable module decorators into class decorators.
