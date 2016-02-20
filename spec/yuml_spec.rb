require 'spec_helper'
require 'pp'
require_relative '../lib/yuml'

describe YUML do
  before :all do
    @doc_uml = "[Document|+foo;+bar|+foo(name#{YUML::ESCAPE_CHARACTERS[',']} other = nil);+bar()]"
  end

  describe '#class' do
    before :each do
      @uut = YUML.class do |c|
        c.name 'Document'
        c.variables('+foo', '+bar')
        c.methods('+foo(name, other = nil)', '+bar()')
      end
    end

    it 'should return a YUML::Class' do
      expect(@uut).to be_an_instance_of YUML::Class
    end

    context 'it should work when given an arity > 0' do
      it 'takes a block and builds a YUML::Class' do
        expect(@uut.to_s).to eq @doc_uml
      end
    end

    context 'it should work when given with instance_eval' do
      it 'takes a block and builds a YUML::Class' do
        doc = YUML.class do
          name 'Document'
          variables('+foo', '+bar')
          methods('+foo(name, other = nil)', '+bar()')
        end
        expect(doc.to_s).to eq @doc_uml
      end
    end
  end
end
