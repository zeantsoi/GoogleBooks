require 'spec_helper'

module GoogleBooks
  describe Response do

    VCR.use_cassette("gatsby", record: :once) do
      request = GoogleBooks.search('the great gatsby') 
      let(:response) { request }
    end

    VCR.use_cassette("empty", record: :once) do
      request = GoogleBooks.search('')
      let(:empty_query) { request }
    end

    it "should set total results" do
      expect(response.total_items).to be > 0
    end

    it "should return entries" do
      expect(response.first).to be_an Item
    end

    it "should handle an empty query" do
      expect(empty_query.to_a).to be_empty
    end
  end
end
