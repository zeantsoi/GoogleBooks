require 'spec_helper'

module GoogleBooks
  describe Response do

    it "should set total results" do
      response = GoogleBooks.search('deleuze')
      response.total_items.should > 0
    end

    it "should return entries" do
      response = GoogleBooks.search('deleuze')
      response.first.should be_an Item
    end

    context "when there is a single match" do
      it "should return entries" do
        GoogleBooks.search('9781443411080').first.should be_an Item
      end
    end

    it "should handle an empty query" do
      GoogleBooks.search('').to_a.should be_empty
    end
  end
end
