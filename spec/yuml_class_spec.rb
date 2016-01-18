require 'spec_helper'
require 'pp'
require_relative '../lib/yuml_generator'

describe YUMLClass do
  before :each do
    @uut = YUMLClass.new
  end

  describe '#new' do
    it 'takes no parameters and returns a YUMLClass object' do
      expect(@uut).to be_an_instance_of(YUMLClass)
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

  describe '#add_public_variables' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.add_public_variables(:foo, :bar)
      expect(@uut.to_s).to eq '[Document|+foo;+bar]'
    end
  end

  describe '#add_private_variables' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.add_private_variables(:foo, :bar)
      expect(@uut.to_s).to eq '[Document|-foo;-bar]'
    end
  end

  describe '#add_public_methods' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.add_public_methods({ foo: [:name, 'other = nil'] }, :bar)
      expect(@uut.to_s).to eq '[Document|+foo(name, other = nil);+bar()]'
    end
  end

  describe '#add_private_methods' do
    before :each do
      @uut.name 'Document'
    end

    it 'takes an array of symbols and adds it to the class' do
      @uut.add_private_methods({ foo: [:name, 'other = nil'] }, :bar)
      expect(@uut.to_s).to eq '[Document|-foo(name, other = nil);-bar()]'
    end
  end

  describe '#has_a' do
    before :each do
      yuml = YUML.new
      @doc = yuml.class do |c|
        c.name 'Document'
        c.add_public_variables(:foo, :bar)
        c.add_public_methods({ foo: [:name, 'other = nil'] }, :bar)
      end
      @pic = yuml.class do |c|
        c.name 'Picture'
        c.add_public_methods(:bar)
        c.add_private_variables(:foo)
      end
      @doc_uml = '[Document|+foo;+bar|+foo(name, other = nil);+bar()], '
    end

    it 'should handle composition' do
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
      yuml = YUML.new
      @doc = yuml.class do |c|
        c.name 'Document'
        c.add_public_variables(:foo, :bar)
        c.add_public_methods({ foo: [:name, 'other = nil'] }, :bar)
      end
      @pic = yuml.class do |c|
        c.name 'Picture'
        c.add_public_methods(:bar)
        c.add_private_variables(:foo)
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
