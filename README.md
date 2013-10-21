# Showcase [![Build Status](https://travis-ci.org/stefanoverna/showcase.png?branch=master)](https://travis-ci.org/stefanoverna/showcase) [![Coverage Status](https://coveralls.io/repos/stefanoverna/showcase/badge.png?branch=master)](https://coveralls.io/r/stefanoverna/showcase)

A simple (< 100 lines of code) but powerful exhibit/presenter implementation.
It's framework agnostic: works with Rails, Padrino or just Sinatra.

Since version 0.2.0 Showcase is bundled with [a set of optional "traits"](https://github.com/stefanoverna/showcase#traits)
you can pick and choose to augment your presenters with additional sugar
(available in Rails 3+ only).

## Why should I use presenters in my Rails app?

See [Avdi's Exhibits introductory post](http://devblog.avdi.org/2012/06/04/displaycase-gem-now-available/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'showcase'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install showcase
```

## Usage

With Rails, you're already set, move on! With Padrino, include `Showcase::Helpers`
in your app `helpers` block.

```ruby
helpers do
  include Showcase::Helpers
end
```

You can now instantiate new presenters in your controller/views using the
included helpers:

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

  # automatically wraps the attribute into an AdminPresenter
  presents :person, with: AdminPresenter

  # expects project.task to return an enumerable. automatically wraps each task
  # in a TaskPresenter presenter
  presents_collection :tasks

  # you can use `view_context`, or the shortcut `h`, to access the context.
  # `object` refers to the object being presented
  def title
    h.link_to object.title, object
  end
end
```

## Rails

### Generators

Showcase comes with a generator to create new presenters a little faster:

```
rails generate showcase:presenter User
```

Will generate `app/presenters/user_presenter.rb`. If your Rails app has the file
`app/presenters/base_presenter.rb`, the newly created presenter will inherit
from `BasePresenter` instead of `Showcase::Presenter`.

### Traits

Please [read the tests](https://github.com/stefanoverna/showcase/tree/master/lib/showcase/traits) 
for a detailed explanation of each method available.

#### `Showcase::Traits::Record`

To be used to present ActiveModel-based records. Inside your presenter, include
the trait like this:

```ruby
class ProjectPresenter < Showcase::Presenter
  include Showcase::Traits::Record
end
```

##### `#dom_id`

```ruby
present(@project).dom_id # => "project_12"
```

##### `#dom_class`

```ruby
present(@project).dom_class # => "project"
```

##### `#box`

Super useful in acceptance testing to check the presence of a record inside a
view:

```erb
<% present(@project, class: 'big').box do %>
  <p>Hi there!</p>
<% end %>
```

Produces the following:

```html
<div class="project big" id="project_12">
  <p>Hi there</p>
</div>
```

Additional HTML attributes can be optionally specified within a config block 
inside the presenter:

```ruby
class ProjectPresenter < Showcase::Presenter
  include Showcase::Traits::Record

  box do |c|
    c.html_options class: 'another-class', role: 'project'
  end
end
```

#### `Showcase::Traits::LinkTo`

Adds a nice DSL to declare links within your presenter.

```ruby
class ProjectPresenter < Showcase::Presenter
  include Showcase::Traits::LinkTo

  link_to do |c|
    c.url           h.project_path(self)
    c.label         name
    c.active        h.controller_name == 'projects'
    c.active_class  'current'
    c.html_options  role: 'label'
  end

  link_to :tasks do
    c.url     h.project_tasks_path(self)
    c.label   "Tasks"
  end
end
```

In your views:

```erb
<%= project.url %>
<%= project.tasks_url %>

<%= project.link_active? %>
<%= project.tasks_link_active? %>

<%= project.link %>
<%= project.tasks_link %>

<%= project.link('Alternative label') %>
<%= project.link(class: 'additional_class') %>
<%= project.link do %>
  Link content!
<% end %>
```

#### `Showcase::Traits::Share`

Useful to produce social share links:

```ruby
class ProjectPresenter < Showcase::Presenter
  include Showcase::Traits::Share

  share do |c|
    c.url         h.project_path(self)
    c.text        name
    c.image_url   cover_image
  end
end
```
In your views:

```erb
<%= project.twitter_share_url %>
<%= project.twitter_share_link %>
<%= project.twitter_share_link('Alternative label') %>
<%= project.twitter_share_link(class: 'additional_class') %>
<%= project.twitter_share_link do %>
  Link content!
<% end %>

<%= project.facebook_share_link %>
<%= project.gplus_share_link %>
<%= project.pinterest_share_link %>
<%= project.linkedin_share_link %>
```

#### `Showcase::Traits::Seo`

Useful to produce SEO meta tags (title, description, Facebook OpenGraph,
Twitter cards, and canonical URLs):

```ruby
class ProjectPresenter < Showcase::Presenter
  include Showcase::Traits::Seo

  seo do |c|
    c.title           name
    c.description     [ description, 'Fallback description if blank' ]
    c.image_url       cover_thumb_image
    c.canonical_url   h.project_path(self)
  end
end
```

In your views:

```erb
<% content_for(:head) do %>
  <%= present(@project).seo_tags(title_suffix: ' - BaseClump') %>
<% end %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

