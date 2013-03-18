# BasicPresenter [![Build Status](https://travis-ci.org/stefanoverna/basic_presenter.png?branch=master)](https://travis-ci.org/stefanoverna/basic_presenter)

The most basic presenter implementation in town (< 100 lines of code). Framework agnostic, works with Rails, Padrino or simply Sinatra.

## Installation

Add this line to your application's Gemfile:

    gem 'basic_presenter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install basic_presenter

## Usage

Include BasicPresenter::Helpers as additional helper module.

```ruby
class ApplicationController < ActionController::Base
  helper BasicPresenter::Helpers
end
```

You can now instantiate new presenters in your controller/views using the included helpers:

```ruby
# this is the object that needs to be presented
person = Person.new

# automatically infers presenter class to use based on person's class name
present(person) # => returns a PersonPresenter instance

# you can also explicitly tell what presenter to use
present(person, AdminPresenter) # => returns an AdminPresenter instance

# explicit presenter and context
present(person, PersonPresenter, context)

# maps each person in the collection with a presenter
present_collection([ people ]) # => returns an array of PeoplePresenters
```

Define your presenters i.e. in a `app/presenters` folder:

```ruby
class ProjectPresenter < BasicPresenter::Base
  # automatically wraps the attribute into a PersonPresenter
  presents :person

  # expects project.task to return an enumerable. automatically wraps each task in a TaskPresenter presenter
  presents_collection :tasks

  # you can use `context`, or the shortcut `h`, to access the view context.
  # `object` refers to the object being presented
  def title
    h.link_to object.title, object
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
