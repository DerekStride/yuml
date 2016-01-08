require 'spec_helper'
require 'pp'
require_relative '../uml'

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

  describe '#has_a' do
    before :each do
      @doc = @uut.class do |c|
        c.name 'Document'
        c.add_public_variables(:foo, :bar)
        c.add_public_methods({ foo: [:name, 'other = nil'] }, :bar)
      end
    end

    it 'should handle composition' do
      relationship = @uut.has_a(@doc, @doc, :aggregation)
      expect(relationship.to_s).to eq "#{@doc}+->#{@doc}"
    end

    it 'should handle composition and cardinality' do
      relationship = @uut.has_a(@doc, @doc, :composition, [0, '*'])
      expect(relationship.to_s).to eq "#{@doc}++0-*>#{@doc}"
    end
  end
end
