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

  def owner_child
  end

  def foobar
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

class AdminPresenter < PersonPresenter
  def bold_name
    h.bold("Admin #{object.name}")
  end
end

class ProjectPresenter < Showcase::Presenter
  presents :owner, with: AdminPresenter
  presents_collection :collaborators
  presents :owner_child
  presents :foobar, nil_presenter: true

  def name
    "Presented #{object.name}"
  end

  def owner
    super
  end

  def bold_name
    h.bold(object.name)
  end

  def first_collaborator
    present(object.first_collaborator)
  end
end

class NilClassPresenter < Showcase::Presenter
  def hi
    "hi!"
  end
end

class Context
  include Showcase::Helpers

  def bold(text)
    "**#{text}**"
  end
end

class Shop
  def owner
    Person.new("Stefano Verna")
  end
end

