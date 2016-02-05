require 'spec_helper'
require 'pp'
require_relative '../lib/yuml'

describe YUML do
  describe '#class' do
    context 'it should work when given an arity > 0' do
      it 'should return a YUML::Class' do
        doc = YUML.class do |c|
          c.name 'Document'
          c.public_variables(:foo, :bar)
          c.public_methods({ foo: [:name, 'other = nil'] }, :bar)
        end
        expect(doc).to be_an_instance_of YUML::Class
      end

      it 'takes a block and builds a YUMLClass' do
        doc_uml = '[Document|+foo;+bar|+foo(name, other = nil);+bar()]'
        doc = YUML.class do |c|
          c.name 'Document'
          c.public_variables(:foo, :bar)
          c.public_methods({ foo: [:name, 'other = nil'] }, :bar)
        end
        expect(doc.to_s).to eq doc_uml
      end
    end

    context 'it should work when given with instance_eval' do
      it 'takes a block and builds a YUMLClass' do
        doc_uml = '[Document|+foo;+bar|+foo(name, other = nil);+bar()]'
        doc = YUML.class do
          name 'Document'
          public_variables :foo, :bar
          public_methods({ foo: [:name, 'other = nil'] }, :bar)
        end
        expect(doc.to_s).to eq doc_uml
      end
    end
  end
end

# UML.generate do |uml|
#   document = uml.class do |c|
#     c.name 'Document'
#     c.public_variables(:foo, :bar)
#     c.public_methods({ foo: [:name, 'other = nil'] }, :bar)
#   end
#
#   picture = @uut.class do |c|
#     c.name 'Picture'
#     c.public_methods(:bar)
#     c.private_variables(:foo)
#   end
#
#   content = uml.class do |c|
#     c.name 'Content'
#   end
#
#   element = uml.class do |c|
#     c.name 'Element'
#   end
#
#   document.is_a(content, :inheritance)
#   picture.is_a(content, :inheritance)
#   content.is_a(element, :interface)
# end
