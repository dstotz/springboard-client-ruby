require 'spec_helper'

describe Addressable::URI do
  let(:uri) { Addressable::URI.parse('/relative/path') }

  describe "subpath" do
    it "should return a new URI with the path relative to the receiver" do
      expect(uri.subpath('other')).to eq(Addressable::URI.parse('/relative/path/other'))
      expect(uri.subpath('/other')).to eq(Addressable::URI.parse('/relative/path/other'))
      uri.subpath(Addressable::URI.parse('/other')) == Addressable::URI.parse('/relative/path/other')
    end
  end

  describe "merge_query_values!" do
    it "should call springboard_query_values=" do
      uri.query_values = {'a' => '1'}
      expect(uri).to receive(:springboard_query_values=).with({'a' => '1', 'b' => '2'})
      uri.merge_query_values! 'b' => '2'
    end

    it "should merge the given values with the existing query_values" do
      uri.query_values = {'a' => '1', 'b' => '2'}
      uri.merge_query_values! 'b' => '20', 'c' => '30'
      expect(uri.query_values).to eq({'a' => '1', 'b' => '20', 'c' => '30'})
    end

    it "should set the given values if there are no existing query_values" do
      expect(uri.query_values).to be_nil
      uri.merge_query_values! 'b' => '20', 'c' => '30'
      expect(uri.query_values).to eq({'b' => '20', 'c' => '30'})
    end
  end

  describe "springboard_query_values=" do
    it "should preserve empty bracket notation for array params" do
      uri.query = 'sort[]=f1&sort[]=f2'
      uri.__send__(:springboard_query_values=, uri.query_values)
      expect(uri.to_s).to eq('/relative/path?sort[]=f1&sort[]=f2')
    end

    it "should stringify boolean param values" do
      uri.__send__(:springboard_query_values=, {:p1 => true, :p2 => false})
      expect(uri.to_s).to eq('/relative/path?p1=true&p2=false')
    end

    it "should support hash param values" do
      uri.__send__(:springboard_query_values=, {:a => {:b => {:c => 123}}})
      expect(uri.to_s).to eq('/relative/path?a[b][c]=123')
    end
  end
end
