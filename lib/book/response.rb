require 'book/item'

module GoogleBooks
  class Response
    include Enumerable

    def initialize(response)
      @response = response
    end

    def each(&block)
      return [] if total_items == 0
      @response['items'].each do |item|
        block.call(Item.new(item))
      end
    end
    
    def total_items
      @response['totalItems'].to_i
    end

  end
end
