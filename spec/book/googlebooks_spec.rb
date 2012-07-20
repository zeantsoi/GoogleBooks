require 'spec_helper'

describe GoogleBooks do
  describe "#search" do
    it "should escape spaces" do
      GoogleBooks.search('damien white')
      GoogleBooks.send(:query).should include 'q=damien+white'
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
		  
		  it "should default to 0 page number isnt specified by count is" do
		  	GoogleBooks.search('the great gatsby', :count => 15)
		  end
		end

    it "should set the number of results per page" do
      GoogleBooks.search('damien white', :count => 20)
      GoogleBooks.send(:query).should include 'maxResults=20'
    end
    
    it "should join parameters" do
      GoogleBooks.search('damien white', :count => 20, :page => 2)
      GoogleBooks.send(:query).should include 'startIndex=2'
      GoogleBooks.send(:query).should include 'maxResults=20'
      GoogleBooks.send(:query).should include 'q=damien+white'
      GoogleBooks.send(:query).count('&').should eq 2 
    end
    
    it "should return the proper number results based on the count passed in" do
      results = GoogleBooks.search('F. Scott Fitzgerald', :count => 20)
      results.count.should eq 20
    end

    it "should return a response" do
      GoogleBooks.search('foo bar').should be_a GoogleBooks::Response
    end
  end
end

