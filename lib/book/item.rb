module GoogleBooks

  class Item
    attr_reader :kind, :id, :title, :authors, :publisher, :published_date, :description, :isbn, :isbn_10, :isbn_13, :other_identifier, :page_count, :print_type, :categories, :average_rating, :ratings_count, :language, :preview_link, :info_link, :sale_info

    def initialize(item)
      @item = item
      @volume_info = @item['volumeInfo']
      retrieve_attribute
    end

    # Enables image_link attribute to be customized via passing
    # optional zoom and edge arguments as a hash
    def image_link(opts = {})
    	opts[:zoom] ||= 1
    	opts[:curl] ||= false
     	@volume_info['imageLinks']['thumbnail'].gsub('zoom=1', "zoom=#{opts[:zoom]}").gsub('&edge=curl', "&edge=#{opts[:curl] ? 'curl' : 'none'}") rescue nil
    end

  private

  	def retrieve_attribute
    	@kind = @item['kind']
    	@id = @item['id']
    	@title = build_title
    	@authors = [@volume_info['authors']].flatten.join(', ')
    	@publisher = @volume_info['publisher']
    	@published_date = @volume_info['publishedDate']
    	@description = @volume_info['description']

      # ISBN_13
    	@isbn = @volume_info['industryIdentifiers'][1]['identifier'] rescue nil
      @isbn_13 = @isbn

      # ISBN_10
      @isbn_10 = @volume_info['industryIdentifiers'].find {|identifier_hash|
        identifier_hash['type'] == "ISBN_10"
      }['identifier'] rescue nil

      # OTHER_IDENTIFIER
      @other_identifier = @volume_info['industryIdentifiers'].find {|identifier_hash|
        identifier_hash['type'] == "OTHER"
      }['identifier'] rescue nil

    	@page_count = @volume_info['pageCount']
    	@print_type = @volume_info['printType']
    	@categories = [@volume_info['categories']].flatten.join(', ')
			@average_rating = @volume_info['averageRating']
			@ratings_count = @volume_info['ratingsCount']
			@language = @volume_info['language']
			@preview_link = @volume_info['previewLink']
			@info_link = @volume_info['infoLink']
      @sale_info = @item['saleInfo']
   	end

   	def build_title
   		title = [@volume_info['title']].flatten.join(': ')
			@volume_info['subtitle'].nil? ? title : title + ": " + @volume_info['subtitle']
		end
  end

end
