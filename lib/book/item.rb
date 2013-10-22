module GoogleBooks

  class Item
    attr_reader :kind, :id, :title, :titles_array, :authors, :authors_array, :publisher, :published_date, :description, :isbn, :isbn_10, :isbn_13, :other_identifier, :page_count, :print_type, :categories, :average_rating, :ratings_count, :language, :preview_link, :info_link, :sale_info

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
      @titles_array = [@volume_info['title'], @volume_info['subtitle']].compact
      @authors = [@volume_info['authors']].flatten.join(', ')
      @authors_array = [@volume_info['authors']].flatten
      @publisher = @volume_info['publisher']
      @published_date = @volume_info['publishedDate']
      @description = @volume_info['description']

      retrieve_industry_identifiers

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

    def retrieve_industry_identifiers

      return unless @volume_info['industryIdentifiers']

      @volume_info['industryIdentifiers'].each do |identifier_hash|
        identifier = identifier_hash["identifier"]

        case identifier_hash['type']
        when "ISBN_13"
          @isbn = @isbn_13 = identifier
        when "ISBN_10"
          @isbn_10 = identifier
        when "OTHER"
          @other_identifier = identifier
        end
      end

    end
  end

end
