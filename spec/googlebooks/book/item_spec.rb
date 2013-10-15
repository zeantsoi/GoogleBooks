require 'spec_helper'

module GoogleBooks
  class Item
    describe Item do

      example = GoogleBooks.search('isbn:9780062132345').first

      it "should append a subtitle to the title if it exists" do
        example.title.should eq "Freakonomics: A Rogue Economist Explores the Hidden Side of Everything"
      end

      it "should return a string authors delineated by a comma" do
        example.authors.should eq "Steven D. Levitt, Stephen J. Dubner"
      end

      it "should return an array of author names" do
        example.author_names.should eq ["Steven D. Levitt", "Stephen J. Dubner"]
      end

      it "should have an isbn that is 13 digits" do
        example.isbn.should_not eq nil
        example.isbn.should eq '9780062132345'
        example.isbn.to_s.length.should eq 13
      end

      it "should convert to a 10 digit isbn" do
        example.isbn_10.should eq '0062132342'
      end

      it "should make a 13 digit isbn duplicated from the default isbn" do
        example.isbn_13.should eq '9780062132345'
        example.isbn_13.should eq example.isbn
      end

      describe "image_link" do
        it "should have all zoom varieties and show 1 as a default" do
          example.image_link.should include "zoom=1"
          example.image_link(:zoom => 2).should include "zoom=2"
          example.image_link(:zoom => 3).should include "zoom=3"
          example.image_link(:zoom => 4).should include "zoom=4"
          example.image_link(:zoom => 5).should include "zoom=5"
          example.image_link(:zoom => 6).should include "zoom=6"
          example.image_link(:zoom => 7).should include "zoom=7"
        end

        it "should default to 'edge=none' and curl when dictated" do
          example.image_link.should include "edge=none"
          example.image_link(:curl => true).should include "edge=curl"
        end

        context "when google_book_item has no isbn_10 but one OTHER industry identifiers" do

          let(:google_book_item) {
            {
              "volumeInfo" => {
                "industryIdentifiers" => [
                  {
                    "type" => "OTHER",
                    "identifier" => "GENT:900000054512"
                  }
                ]
              }
            }
          }
          let(:item) { Item.new google_book_item }
          subject { item }

          its(:isbn_10) { should be_nil }
          its(:other_identifier) { should == "GENT:900000054512" }
        end
      end

    end
  end
end
