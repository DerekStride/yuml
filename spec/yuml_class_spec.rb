require 'spec_helper'
require 'pp'
require_relative '../lib/yuml'

describe YUML::Class do
  before :each do
    @uut = YUML::Class.new
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

  describe '#public_variables' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.public_variables(:foo, :bar)
      expect(@uut.to_s).to eq '[Document|+foo;+bar]'
    end
  end

  describe '#private_variables' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.private_variables(:foo, :bar)
      expect(@uut.to_s).to eq '[Document|-foo;-bar]'
    end
  end

  describe '#public_methods' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.public_methods({ foo: [:name, 'other = nil'] }, :bar)
      expect(@uut.to_s).to eq '[Document|+foo(name, other = nil);+bar()]'
    end
  end

  describe '#private_methods' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.private_methods({ foo: [:name, 'other = nil'] }, :bar)
      expect(@uut.to_s).to eq '[Document|-foo(name, other = nil);-bar()]'
    end
  end

  describe '#has_a' do
    before :each do
      @doc = YUML.class do |c|
        c.name 'Document'
        c.public_variables(:foo, :bar)
        c.public_methods({ foo: [:name, 'other = nil'] }, :bar)
      end
      @pic = YUML.class do |c|
        c.name 'Picture'
        c.public_methods(:bar)
        c.private_variables(:foo)
      end
      @doc_uml = '[Document|+foo;+bar|+foo(name, other = nil);+bar()], '
    end

    it 'should handle aggregation' do
      @doc.has_a(@pic)
      expect(@doc.to_s).to eq "#{@doc_uml}[Document]+->[Picture]"
    end

    it 'should handle composition and cardinality' do
      @doc.has_a(@pic, type: :composition, cardinality: [0, '*'])
      expect(@doc.to_s).to eq "#{@doc_uml}[Document]++0-*>[Picture]"
    end
  end

  describe '#is_a' do
    before :each do
      @doc = YUML.class do |c|
        c.name 'Document'
        c.public_variables(:foo, :bar)
        c.public_methods({ foo: [:name, 'other = nil'] }, :bar)
      end
      @pic = YUML.class do |c|
        c.name 'Picture'
        c.public_methods(:bar)
        c.private_variables(:foo)
      end
      @doc_uml = '[Document|+foo;+bar|+foo(name, other = nil);+bar()], '
    end

    it 'should handle inheritance' do
      @doc.is_a(@pic, type: :inheritance)
      expect(@doc.to_s).to eq "#{@doc_uml}[Picture]^-[Document]"
    end

    it 'should handle interface' do
      @doc.is_a(@pic, type: :interface)
      expect(@doc.to_s).to eq "#{@doc_uml}[Picture]^-.-[Document]"
    end
  end
end
