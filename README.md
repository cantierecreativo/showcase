# Showcase [![Build Status](https://travis-ci.org/welaika/showcase.png?branch=master)](https://travis-ci.org/welaika/showcase) [![Coverage Status](https://coveralls.io/repos/welaika/showcase/badge.png?branch=master)](https://coveralls.io/r/welaika/showcase)

A simple (< 100 lines of code) but powerful exhibit/presenter implementation. It's framework agnostic: works with Rails, Padrino or simply Sinatra.

# Properties of the Exhibit pattern

Citing [Avdi's introductory post](http://devblog.avdi.org/2012/06/04/displaycase-gem-now-available/):

* **It wraps a single model instance.** Not an assortment of objects.
* **It is a true Decorator.** All unrecognized messages are passed through to the underlying object. This facilitates a gradual migration to the use of Exhibits to encapsulate presentation knowledge, since they can be layered onto models without any change to the existing views. It also enables multiple Exhibits to be layered onto an object, each handling different aspects of presentation.
* **It brings together a model and a context.** Exhibits need a reference to a “context” object—either a controller or a view context—in order to be able to render templates as well as construct URLs for the object or related resources.
* **It encapsulates decisions about how to render an object.** The tell-tale of an Exhibit is telling an object “render yourself”, rather than explicitly rendering a template and passing the object in as an argument.
* **It may modify the behavior of an object.** For instance, an Exhibit might impose a scope on a Blog#entries association which only returns entries that are visible to the current user (as determined from the Exhibit’s controller context). Or it might reformat the return value of a #social_security_number method to include dashes and have all but the last four digits obscured: ***-**-5678.
* **There is a many-to-many relationship between model classes and exhibit classes.** One generic exhibit class may apply to several different types of model. Other exhibits may be specific, not just to a model, but to a model in a particular state, or within a particular viewing context.

## Installation

Add this line to your application's Gemfile:

    gem 'showcase'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install showcase

## Usage

With Rails, include `Showcase::Helpers` into your controller and/or views:

```ruby
# config/initializers/showcase.rb
ActionController::Base.send :include, Showcase::Helpers
ActionView::Base.send :include, Showcase::Helpers
```

With Padrino, include `Showcase::Helpers` in your app `helpers` block.

```ruby
helpers do
  include Showcase::Helpers
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
present_collection([person]) # => returns an array of PersonPresenters
```

Define your presenters i.e. in a `app/presenters` folder:

```ruby
class ProjectPresenter < Showcase::Presenter
  # automatically wraps the attribute into a PersonPresenter
  presents :person

  # expects project.task to return an enumerable. automatically wraps each task in a TaskPresenter presenter
  presents_collection :tasks

  # you can use `view_context`, or the shortcut `h`, to access the context.
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

