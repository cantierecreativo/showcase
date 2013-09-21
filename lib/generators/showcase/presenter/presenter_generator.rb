module Showcase
  module Generators
    class PresenterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_presenter
        @base_presenter = File.exist?('app/presenters/base_presenter.rb') ? "BasePresenter" : "Showcase::Presenter"
        template 'presenter.rb', File.join('app/presenters', class_path, "#{file_name}_presenter.rb")
      end
    end
  end
end

