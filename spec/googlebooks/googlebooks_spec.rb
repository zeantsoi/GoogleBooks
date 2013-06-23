require 'spec_helper'

describe GoogleBooks do
  describe "#search" do
    it "should escape spaces" do
      GoogleBooks.search('the great gatsby')
      GoogleBooks.send(:query).should include 'q=the+great+gatsby'
    end

    describe 'startIndex' do
      it "should default to 0 if no page is specified" do
        GoogleBooks.search('the great gatsby')
        GoogleBooks.send(:query).should include 'startIndex=0'
      end

      it "should calculate based on default count of 5 if no count is given" do
        GoogleBooks.search("the great gatsby", :page => 4)
        GoogleBooks.send(:query).should include 'startIndex=15'
      end

      it "should set based on page number and count" do
        GoogleBooks.search('the great gatsby', {:page => 3, :count => 12})
        GoogleBooks.send(:query).should include 'startIndex=24'
      end
    end

    it "should set the number of results per page" do
      GoogleBooks.search('the great gatsby', :count => 20)
      GoogleBooks.send(:query).should include 'maxResults=20'
    end

    it "should join parameters" do
      GoogleBooks.search('the great gatsby', :filter => "free-ebooks", :count => 20, :page => 2)
      GoogleBooks.send(:query).should include 'startIndex=2'
      GoogleBooks.send(:query).should include 'maxResults=20'
      GoogleBooks.send(:query).should include 'q=the+great+gatsby'
      GoogleBooks.send(:query).should include 'filter=free-ebooks'
      GoogleBooks.send(:query).count('&').should eq 3
    end

    it "should return the proper number results based on the count passed in" do
      results = GoogleBooks.search('F. Scott Fitzgerald', :count => 20)
      results.count.should eq 20
    end

    it "should return a response" do
      GoogleBooks.search('the great gatsby').should be_a GoogleBooks::Response
    end
  end
end

