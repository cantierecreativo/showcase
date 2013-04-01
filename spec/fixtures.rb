class Person < Struct.new(:name)
end

class Project < Struct.new(:name)
  def owner
    Person.new("Stefano Verna")
  end

  def collaborators
    [ Person.new("Ju Liu") ]
  end

  def first_collaborator
    collaborators.first
  end

  def dummy
    "foobar"
  end
end

class PersonPresenter < Showcase::Presenter
  def sex
    'male'
  end

  def bold_name
    h.bold(object.name)
  end
end

class ProjectPresenter < Showcase::Presenter
  presents :owner
  presents_collection :collaborators

  def name
    "Presented #{object.name}"
  end

  def bold_name
    h.bold(object.name)
  end

  def first_collaborator
    present(object.first_collaborator)
  end
end

class Context
  include Showcase::Helpers

  def bold(text)
    "**#{text}**"
  end
end
