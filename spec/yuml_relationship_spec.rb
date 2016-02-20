require 'spec_helper'
require 'pp'
require_relative '../lib/yuml'

describe YUML::Relationship do
  describe '#inheritance' do
    it 'should return the default inheritance relationship' do
      expect(YUML::Relationship.inheritance).to eq '^-'
    end
  end

  describe '#interface' do
    it 'should return the default interface relationship' do
      expect(YUML::Relationship.interface).to eq '^-.-'
    end
  end

  describe '#composition' do
    it 'should return the default composition relationship' do
      expect(YUML::Relationship.composition).to eq '++->'
    end

    it 'should handle a single cardinality' do
      expect(YUML::Relationship.composition('*')).to eq '++-*>'
    end

    it 'should handle a two sided cardinality' do
      expect(YUML::Relationship.composition('1', '*')).to eq '++1-*>'
    end
  end

  describe '#aggregation' do
    it 'should return the default aggregation relationship' do
      expect(YUML::Relationship.aggregation).to eq '+->'
    end

    it 'should handle a single cardinality' do
      expect(YUML::Relationship.aggregation('*')).to eq '+-*>'
    end

    it 'should handle a two sided cardinality' do
      expect(YUML::Relationship.aggregation('1', '*')).to eq '+1-*>'
    end
  end
end
