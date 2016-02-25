require 'spec_helper'
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

  describe '#association' do
    it 'should return the default association relationship' do
      expect(YUML::Relationship.association).to eq '-'
    end

    it 'should handle a single cardinality' do
      expect(YUML::Relationship.association('*')).to eq '-*'
    end

    it 'should handle a two sided cardinality' do
      expect(YUML::Relationship.association('1', '*')).to eq '1-*'
    end
  end

  describe '#two_way_association' do
    it 'should return the default two_way_association relationship' do
      expect(YUML::Relationship.two_way_association).to eq '<->'
    end

    it 'should handle a single cardinality' do
      expect(YUML::Relationship.two_way_association('*')).to eq '<-*>'
    end

    it 'should handle a two sided cardinality' do
      expect(YUML::Relationship.two_way_association('1', '*')).to eq '<1-*>'
    end
  end

  describe '#directed_assoication' do
    it 'should return the default directed_assoication relationship' do
      expect(YUML::Relationship.directed_assoication).to eq '->'
    end

    it 'should handle a single cardinality' do
      expect(YUML::Relationship.directed_assoication('*')).to eq '-*>'
    end

    it 'should handle a two sided cardinality' do
      expect(YUML::Relationship.directed_assoication('1', '*')).to eq '1-*>'
    end
  end

  describe '#dependency' do
    it 'should return the default dependency relationship' do
      expect(YUML::Relationship.dependency).to eq '-.->'
    end

    it 'should handle a single cardinality' do
      expect(YUML::Relationship.dependency('*')).to eq '-.-*>'
    end

    it 'should handle a two sided cardinality' do
      expect(YUML::Relationship.dependency('1', '*')).to eq '1-.-*>'
    end
  end
end
