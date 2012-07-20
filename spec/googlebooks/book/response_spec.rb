require 'spec_helper'

module GoogleBooks
  describe Response do

    response = GoogleBooks.search('the great gatsby')

    it "should set total results" do
      response.total_items.should > 0
    end

    it "should return entries" do
      response.first.should be_an Item
    end

    it "should handle an empty query" do
      GoogleBooks.search('').to_a.should be_empty
    end
  end
end
