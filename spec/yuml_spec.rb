require 'spec_helper'
require 'pp'
require_relative '../lib/yuml_generator'

describe YUML do
  before :each do
    @uut = YUML.new
  end

  describe '#new' do
    it 'takes no parameters and returns a YUML object' do
      expect(@uut).to be_an_instance_of(YUML)
    end
  end

  describe '#class' do
    it 'takes a block and builds a YUMLClass' do
      doc_uml = '[Document|+foo;+bar|+foo(name, other = nil);+bar()]'
      doc = @uut.class do |c|
        c.name 'Document'
        c.add_public_variables(:foo, :bar)
        c.add_public_methods({ foo: [:name, 'other = nil'] }, :bar)
      end
      expect(doc.to_s).to eq doc_uml
    end
  end
end

# UML.generate do |uml|
#   document = uml.class do |c|
#     c.name 'Document'
#     c.add_public_variables(:foo, :bar)
#     c.add_public_methods({ foo: [:name, 'other = nil'] }, :bar)
#   end
#
#   picture = @uut.class do |c|
#     c.name 'Picture'
#     c.add_public_methods(:bar)
#     c.add_private_variables(:foo)
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
