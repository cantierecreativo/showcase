class Person < Struct.new(:name)
end

class Project < Struct.new(:name)
  def owner
    Person.new("Stefano Verna")
  end

  def collaborators
    [ Person.new("Ju Liu") ]
  end

  def dummy
    "foobar"
  end
end

class PersonPresenter < BasicPresenter::Base
  def sex
    'male'
  end
end

class ProjectPresenter < BasicPresenter::Base
  presents :owner
  presents_collection :collaborators

  def name
    "Presented #{object.name}"
  end

  def context_foo
    h.foo
  end
end

class Context
  include BasicPresenter::Helpers
end
