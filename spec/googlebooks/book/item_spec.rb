require 'spec_helper'
require 'rspec/its'

module GoogleBooks
  class Item
    describe Item do

      VCR.use_cassette("isbn", record: :once) do
        request = GoogleBooks.search('isbn:9780062132345')
        let(:example) { request.first }
      end

      it "should append a subtitle to the title if it exists" do
        expect(example.title).to eq "Freakonomics: A Rogue Economist Explores the Hidden Side of Everything"
      end

      it "should return an array of all titles" do
        expect(example.titles_array).to include(*["Freakonomics", "A Rogue Economist Explores the Hidden Side of Everything"])
      end

      it "should return a string authors delineated by a comma" do
        expect(example.authors).to eq "Steven D. Levitt, Stephen J. Dubner"
      end

      it "should return an array of author names" do
        expect(example.authors_array).to include(*["Steven D. Levitt", "Stephen J. Dubner"])
      end

      it "should have an isbn that is 13 digits" do
        expect(example.isbn).not_to eq nil
        expect(example.isbn).to eq '9780062132345'
        expect(example.isbn.to_s.length).to eq 13
      end

      it "should convert to a 10 digit isbn" do
        expect(example.isbn_10).to eq '0062132342'
      end

      it "should make a 13 digit isbn duplicated from the default isbn" do
        expect(example.isbn_13).to eq '9780062132345'
        expect(example.isbn_13).to eq example.isbn
      end

      describe "image_link" do
        it "should have all zoom varieties and show 1 as a default" do
          expect(example.image_link).to include "zoom=1"
          expect(example.image_link(:zoom => 2)).to include "zoom=2"
          expect(example.image_link(:zoom => 3)).to include "zoom=3"
          expect(example.image_link(:zoom => 4)).to include "zoom=4"
          expect(example.image_link(:zoom => 5)).to include "zoom=5"
          expect(example.image_link(:zoom => 6)).to include "zoom=6"
          expect(example.image_link(:zoom => 7)).to include "zoom=7"
        end

        it "should default to 'edge=none' and curl when dictated" do
          expect(example.image_link).to include "edge=none"
          expect(example.image_link(:curl => true)).to include "edge=curl"
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
