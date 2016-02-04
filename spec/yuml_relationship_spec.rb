require 'spec_helper'
require 'pp'
require_relative '../lib/yuml'

describe YUML::Relationship do
  describe '#relationship' do
    before :each do
      @uut0 = YUML::Relationship.relationship(type: :aggregation)
      @uut1 = YUML::Relationship.relationship(type: :composition,
                                            cardinality: [0, '*'])
      @uut2 = YUML::Relationship.relationship(type: :inheritance)
      @uut3 = YUML::Relationship.relationship(type: :interface)
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
