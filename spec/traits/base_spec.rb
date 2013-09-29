require 'spec_helper'

module Showcase::Traits
  describe Base do
    describe '.define_method?' do

      it 'defines an instance method' do
        klass = Class.new do
          include Base
          define_method? :foo do
            true
          end
        end

        expect(klass.new.foo).to be_true
      end

      it 'overriding the method allows to call super' do
        klass = Class.new do
          include Base

          define_method? :foo do
            true
          end

          def foo
            super
          end
        end

        expect(klass.new.foo).to be_true
      end

      context 'if the method is already present' do
        it 'no-ops ' do
          klass = Class.new do
            include Base
            def foo; false; end
          end

          expect(klass.new.foo).to be_false
        end
      end

      context 'if method name is an array of chunks' do
        it 'joins them in snake case' do
          klass = Class.new do
            include Base
            define_method? [:foo, :bar] do
              true
            end
          end

          expect(klass.new.foo_bar).to be_true
        end

        it 'ignores blank chunks' do
          klass = Class.new do
            include Base
            define_method? ["", :bar] do
              true
            end
          end

          expect(klass.new.bar).to be_true
        end
      end

    end
  end
end

