require 'book/item'

module Gbooks
  class Response
    include Enumerable

    def initialize(response)
      @response = response
    end

    def each(&block)
      items.each do |item|
        block.call(Item.new(item))
      end
    end
    
    def total_items
      @response['totalItems'].to_i
    end

    private

    def items
      total_items == 0 ? [] : [@response['items']].flatten
    end
  end
end
