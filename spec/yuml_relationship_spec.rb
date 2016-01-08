require 'spec_helper'
require 'pp'
require_relative '../uml'

describe YUMLRelationship do
  before :each do
    @uut0 = YUMLRelationship.new(type: :aggregation)
  end

  describe '#new' do
    it 'takes a hash of params and returns a YUMLRelationship object' do
      expect(@uut0).to be_an_instance_of(YUMLRelationship)
    end
  end

  describe '#to_s' do
    before :each do
      @uut0 = YUMLRelationship.new(type: :aggregation)
      @uut1 = YUMLRelationship.new(type: :composition, cardinality: [0, '*'])
      @uut2 = YUMLRelationship.new(type: :inheritance)
      @uut3 = YUMLRelationship.new(type: :interface)
    end

    it 'should handle aggregation' do
      expect(@uut0.to_s).to eq '+->'
    end

    it 'should handle composition and cardinality' do
      expect(@uut1.to_s).to eq '++0-*>'
    end

    it 'should handle inheritance' do
      expect(@uut2.to_s).to eq '^-'
    end

    it 'should handle interfaces' do
      expect(@uut3.to_s).to eq '^-.-'
    end
  end
end
