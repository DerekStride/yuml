require 'spec_helper'
require_relative '../lib/yuml'

describe YUML do
  before :all do
    @doc_uml = "[Document|+foo;+bar|+foo(name#{YUML::ESCAPE_CHARACTERS[',']} other = nil);+bar()]"
  end

  before :each do
    @uut = YUML.class do |c|
      c.name 'Document'
      c.variables('+foo', '+bar')
      c.methods('+foo(name, other = nil)', '+bar()')
    end
  end

  describe '#class' do
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

  describe '#generate' do
    include FakeFS::SpecHelpers

    before :all do
      @options = { file: 'test.pdf' }
    end

    before :each do
      @stub = stub_request(:any, %r{http://yuml.me/.*}).to_return(body: 'abc', status: 200)
    end

    it 'should yield the block' do
      expect { |b| YUML.generate(@options, &b) }.to(yield_control.once)
    end

    it 'should make the api call' do
      YUML.generate(@options) do |uml|
        uml.class do
          name 'Document'
        end
      end
      expect(@stub).to have_been_requested
    end

    it 'should write the contents to a file' do
      YUML.generate(@options) do |uml|
        uml.class do
          name 'Document'
        end
      end
      expect(File.exist?(@options[:file])).to be true
      expect(File.read(@options[:file])).to eq 'abc'
    end
  end

  describe '#attach_note' do
    it 'should work' do
      expect { YUML.attach_note('test', 'green') }.not_to raise_error
    end
  end
end
