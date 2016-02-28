require 'spec_helper'
require_relative '../lib/yuml'

describe YUML::Note do
  describe '#create' do
    it 'should return a formatted string' do
      note = YUML::Note.create('This diagram blongs to Derek Stride', :green)
      expect(note).to eq '[note: This diagram blongs to Derek Stride{bg:green}]'
    end
  end
end
