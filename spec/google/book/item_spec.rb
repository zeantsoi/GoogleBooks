require 'spec_helper'

module GoogleBooks
  class Item
    describe Item do
      
      example = GoogleBooks.search('isbn:9781935182320').first
      
      it "should have a title" do
        example.title.should eq 'JQuery in Action'
      end
      
      it "should contain a subtitle in the title if there is one" do
        book = GoogleBooks.search('isbn:9780596517748').first
        book.title.should eq 'JavaScript: The Good Parts'
      end
      
      it "should have an array of authors with the correct names" do
        example.authors.should eq "Bear Bibeault, Yehuda Katz"
      end
      
      it "should have a publisher" do
      	example.publisher.should_not eq nil
      end
      
      it "should have an isbn that is 13 digits" do
      	example.isbn.should_not eq nil
      	example.isbn.to_s.length.should eq 13
      end
      
      it "should convert to a 10 digit isbn" do
      	example.isbn_10.should eq '1935182323'
      end
      
      it "should make a 13 digit isbn duplicated from the default isbn" do
      	example.isbn_13.should eq '9781935182320'
      	example.isbn_13.should eq example.isbn
      end
      
      it "should have a description" do
      	example.description.should_not eq nil
      end
      
      it "should have all zoom varieties and show 1 as a default" do
      	example.image_link.should include "zoom=1"
      	example.image_link(2).should include "zoom=2"
		   	example.image_link(3).should include "zoom=3"
		   	example.image_link(4).should include "zoom=4"
		   	example.image_link(5).should include "zoom=5"
		   	example.image_link(6).should include "zoom=6"
		   	example.image_link(7).should include "zoom=7"
      end
      
    end
  end
end
