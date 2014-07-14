require 'spec_helper'

module GoogleBooks
  describe Response do

    response = GoogleBooks.search('the great gatsby')

    it "should set total results" do
      expect(response.total_items).to be > 0
    end

    it "should return entries" do
      expect(response.first).to be_an Item
    end

    it "should handle an empty query" do
      expect(GoogleBooks.search('').to_a).to be_empty
    end
  end
end
