require 'spec_helper'
require 'pp'
require_relative '../lib/yuml_generator'

describe YUMLRelationship do
  before :each do
    @uut0 = YUMLRelationship.relationship(type: :aggregation)
  end

  describe '#relationship' do
    before :each do
      @uut0 = YUMLRelationship.relationship(type: :aggregation)
      @uut1 = YUMLRelationship.relationship(type: :composition,
                                            cardinality: [0, '*'])
      @uut2 = YUMLRelationship.relationship(type: :inheritance)
      @uut3 = YUMLRelationship.relationship(type: :interface)
    end

    it 'should handle aggregation' do
      expect(@uut0).to eq '+->'
    end

    it 'should handle composition and cardinality' do
      expect(@uut1).to eq '++0-*>'
    end

    it 'should handle inheritance' do
      expect(@uut2).to eq '^-'
    end

    it 'should handle interfaces' do
      expect(@uut3).to eq '^-.-'
    end
  end
end
