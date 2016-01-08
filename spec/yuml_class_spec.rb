require 'spec_helper'
require 'pp'
require_relative '../uml'

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
end
