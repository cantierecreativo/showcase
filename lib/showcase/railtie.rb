require 'showcase/traits'

module Showcase
  class Railtie < Rails::Railtie
    initializer "action_view.initialize_showcase" do
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.send :include, Showcase::Helpers::Present
      end
    end
  end
end

