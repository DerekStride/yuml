require 'spec_helper'
require_relative '../lib/yuml'

describe YUML::Class do
  before :each do
    @uut = YUML::Class.new
    @doc = YUML.class do |c|
      c.name 'Document'
      c.variables('+foo', '+bar')
      c.methods(
        '+foo(name, other = nil)',
        '+bar()'
      )
    end
    @pic = YUML.class do |c|
      c.name 'Picture'
      c.methods('+bar()')
      c.variables('-foo')
    end
  end

  describe '#new' do
    it 'takes no parameters and returns a YUML::Class object' do
      expect(@uut).to be_an_instance_of(YUML::Class)
    end
  end

  describe '#name' do
    it 'takes a name and updates the class' do
      @uut.name 'Document'
      expect(@uut.to_s).to eq '[Document]'
    end

    it 'should work with name= as well' do
      @uut.name = 'Document'
      expect(@uut.to_s).to eq '[Document]'
    end
  end

  describe '#variables' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes symbols and adds it to the class' do
      @uut.variables(:foo, :bar)
      expect(@uut.to_s).to eq '[Document|foo;bar]'
    end

    it 'takes strings and adds it to the class' do
      @uut.variables('+foo:String', '-bar:int')
      expect(@uut.to_s).to eq '[Document|+foo:String;-bar:int]'
    end
  end

  describe '#methods' do
    it 'takes an array of symbols and adds it to the class' do
      @uut.name 'Document'
      @uut.methods(
        '+foo(name, other = nil)',
        '-bar()'
      )
      expect(@uut.to_s).to eq "[Document|+foo(name#{YUML::ESCAPE_CHARACTERS[',']} other = nil);-bar()]"
    end
  end

  describe '#has_a' do
    it 'should handle aggregation' do
      @doc.has_a(@pic)
      expect(@doc.relationships).to eq '[Document]+->[Picture]'
    end

    it 'should handle cardinality' do
      @doc.has_a(@pic, cardinality: '*')
      expect(@doc.relationships).to eq '[Document]+-*>[Picture]'
    end

    it 'should handle composition and cardinality' do
      @doc.has_a(@pic, type: :composition, cardinality: [0, '*'])
      expect(@doc.relationships).to eq '[Document]++0-*>[Picture]'
    end
  end

  describe '#is_a' do
    it 'should handle inheritance' do
      @doc.is_a(@pic, type: :inheritance)
      expect(@doc.relationships).to eq '[Picture]^-[Document]'
    end

    it 'should handle interface' do
      @doc.is_a(@pic, type: :interface)
      expect(@doc.relationships).to eq '[Picture]^-.-[Document]'
    end
  end

  describe '#associated_with' do
    it 'should handle a default association' do
      @doc.associated_with(@pic)
      expect(@doc.relationships).to eq '[Document]->[Picture]'
    end

    it 'should handle an association with cardinality' do
      @doc.associated_with(@pic, cardinality: %w(uses used))
      expect(@doc.relationships).to eq '[Document]uses-used>[Picture]'
    end

    it 'should handle a bi directional associations with cardinality' do
      @doc.associated_with(@pic, type: :two_way_association, cardinality: ['used by'])
      expect(@doc.relationships).to eq '[Document]<-used by>[Picture]'
    end

    it 'should handle a undirected association' do
      @doc.associated_with(@pic, type: :association, cardinality: ['used by'])
      expect(@doc.relationships).to eq '[Document]-used by[Picture]'
    end

    it 'should handle a dependency' do
      @doc.associated_with(@pic, type: :dependency, cardinality: %w(uses used))
      expect(@doc.relationships).to eq '[Document]uses-.-used>[Picture]'
    end
  end
end
