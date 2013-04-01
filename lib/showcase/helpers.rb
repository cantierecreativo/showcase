module Showcase
  module Helpers
    def present(obj, klass = nil, context = self)
      if obj.is_a? ::Showcase::Presenter
        obj
      else
        klass ||= "#{obj.class.name}Presenter".constantize
        klass.new(obj, context)
      end
    end

    def present_collection(obj, klass = nil, context = self)
      obj.map { |o| present(o, klass, context) }
    end
  end
end


