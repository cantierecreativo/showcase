module Showcase
  module Generators
    class PresenterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_presenter
        template 'presenter.rb', File.join('app/presenters', class_path, "#{file_name}_presenter.rb")
      end
    end
  end
end
