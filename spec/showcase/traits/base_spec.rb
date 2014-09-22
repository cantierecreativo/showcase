require 'spec_helper'

module Showcase::Traits
  describe Base do
    describe '.define_module_method' do

      it 'defines an instance method' do
        klass = Class.new do
          include Base
          define_module_method :foo do
            true
          end
        end

        expect(klass.new.foo).to be_truthy
      end

      it 'overriding the method allows to call super' do
        klass = Class.new do
          include Base

          define_module_method :foo do
            true
          end

          def foo
            super
          end
        end

        expect(klass.new.foo).to be_truthy
      end

      context 'if the method is already present' do
        it 'no-ops ' do
          klass = Class.new do
            include Base
            def foo; false; end
          end

          expect(klass.new.foo).to be_falsey
        end
      end

      context 'if method name is an array of chunks' do
        it 'joins them in snake case' do
          klass = Class.new do
            include Base
            define_module_method [:foo, :bar] do
              true
            end
          end

          expect(klass.new.foo_bar).to be_truthy
        end

        it 'ignores blank chunks' do
          klass = Class.new do
            include Base
            define_module_method ["", :bar] do
              true
            end
          end

          expect(klass.new.bar).to be_truthy
        end
      end

    end
  end
end

