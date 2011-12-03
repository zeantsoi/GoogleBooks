module Gbooks

  class Item
    attr_reader :item

    def initialize(item)
      @item = item
      @volume_info = @item['volumeInfo']
    end
    
    def kind
    	@item['kind']
    end
    
    def id
    	@item['id']
    end
    
    def title
      [@volume_info['title']].flatten.join(': ')
    end

    def authors
      [@volume_info['authors']].flatten.join(', ')
    end

   	def publisher
      @volume_info['publisher']
    end
    
    def published_date
    	@volume_info['publishedDate']
    end
    
    def description
      @volume_info['description']
    end

   	def isbn
   		@volume_info['industryIdentifiers'][1]['identifier'] rescue nil
   	end
   	
   	def isbn_10
   		@volume_info['industryIdentifiers'][0]['identifier'] rescue nil
   	end
   	
   	def isbn_13
   		isbn
   	end
   	
   	def page_count
   		@volume_info['pageCount']
   	end
   	
   	def print_type
   		@volume_info['printType']
   	end
   	
   	def categories
      [@volume_info['categories']].flatten.join(', ')
    end
    
    def average_rating
    	@volume_info['averageRating']
    end
    
    def ratings_count
    	@volume_info['ratingsCount']
    end
    
    def image_link(zoom = 1, edge = "none")
     	@volume_info['imageLinks']['thumbnail'].gsub('zoom=1', "zoom=#{zoom}").gsub('&edge=curl', "&edge=#{edge}") rescue nil
    end
    
    def language
    	@volume_info['language']
    end
    
    def preview_link
    	@volume_info['previewLink']
    end
    
    def info_link
    	@volume_info['infoLink']
    end

  end

end
