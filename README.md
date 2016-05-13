# Wallaby

![Travis CI](https://travis-ci.org/reinteractive/wallaby.svg)

Wallaby is a Rails engine to manage data, and it can be easily customized in Rails way using controllers and views. You could have a play with the [demo here](https://wallaby-demo.herokuapp.com/admin/)

## Features

- It supports Devise and CanCanCan, and provides configurations for your own authentication.
- Easy setup, ready for use, neat looking. And you won't miss any of these features (search/pagination/sorting/form validation/flash messages).
- No DSL, pure Rails and minimum learning curve required. So it's easy to customize things by extending controllers and partials, and it applies best practices such as Decorator and Service Object. (see [Customization](CUSTOMIZATION.md))

### Support

- Use Bootstrap
- Ruby 2.0.\*, 2.1.\*, 2.2.\*
- Rails 4.\*
- ActiveRecord 4.\*
- Devise
- CanCanCan
- All Postgres data types that ActiveRecord supports, including string, text, integer, float, decimal, datetime, time, date, daterange, numrange, tsrange, tstzrange, int4range, int8range, binary, boolean, bigint, xml, tsvector, hstore, inet, cidr, macaddr, uuid, json, jsonb, ltree, citext, point, bit, bit_varying and money
- Additional support for types including email and color
- Handle ActiveRecord associations, including belongs-to and its polymorphic form, has-one, has-many and has-and-belongs-to-many
- Handle namespaces models, e.g. `Order::Item`

## What's new

# v4.1.0

1. Added concept Mode to allow Wallaby to pick up multiple ORM adaptors apart from ActiveRecord
2. Caching improvements:
  - Cached compiled ERB template (not for development)
  - Most Rails cache implementation for delete_match takes string instead of regex
  - Cached Calculations for finding a subclass
3. Resolve an issue when a file under `/app` folder is not following Rails convention (e.g. class `CSV` in `csv.rb`) or if it is a module declaration under `concerns` folder, it raises load error on booting up Rails server

For more, see [Changelog](CHANGELOG.md)

## Installation

1. Add the following line to `Gemfile`:

    ```ruby
    #!Gemfile
    gem 'wallaby'
    ```

2. Add engine routes to `routes.rb`:

    ```ruby
    #!config/routes.rb
    Rails.application.routes.draw do
      mount Wallaby::Engine => "/the_path_you_like"
      # ... other routes
    end
    ```

Then you are all set to visit Wallaby on your local machine at `/the_path_you_like`. If you are not using Devise for authentication, you will need to do the following configurations.

## Configuration

### Authentication

You could set up authentication via:

1. Easily tell Wallaby which controller (that has `authenticate_user!` and `current_user` methods) to inherit from:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.base_controller = MySecurityController
    end
    ```

    Once this is set, Wallaby will automatically pick up the above mentioned authentication methods (which is compatible with Devise), not to mention all functionalities including application helpers, before_action and etc (which will be beneficial for further development upon Wallaby, see [Customization](CUSTOMIZATION.md)).

2. You could still use custom authentication by configuring the `authenticate` and `current_user` options as below:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.security.authenticate do
        # you could use any controller methods inside this block
        authenticate_or_request_with_http_basic do |username, password|
          username == 'too_simple' && password == 'too_naive'
        end
      end

      config.security.current_user do
        # you could use any controller methods inside this block
        Class.new do
          # email field is for gravator profile image
          def email
            'user@example.com'
          end
        end.new
      end
    end
    ```

For more configurations and How-Toes for Wallaby, see [Customization](CUSTOMIZATION.md).

## License
This project rocks and uses MIT-LICENSE.
