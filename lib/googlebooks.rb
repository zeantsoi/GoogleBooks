require "googlebooks/version"

require "googlebooks/version"

require 'book/response'

require 'httparty'
require 'cgi'

module GoogleBooks
  # A simple wrapper around the Google Book Search API.

  include HTTParty
  format :json
  
  class << self

    # The search parameters.
    attr_accessor :parameters

    # Queries the Google Book Search Data API. Takes a query string and an
    # optional options hash.
    #
    # The options hash respects the following members:
    #
    # * `:page`, which specifies the page.
    #
    # * `:count`, which specifies the number of results per page.
    def search(query, opts = {}, remote_ip = nil)
      (headers 'X-Forwarded-For' => remote_ip.to_s) unless remote_ip.nil?
      self.parameters = { 'q' => query }
      opts[:page] ||= 1
      opts[:count] ||= 5
      parameters['startIndex'] = opts[:count] * (opts[:page] - 1)
      parameters['maxResults'] = opts[:count]

      Response.new(get(url.to_s))
    end

    private

    def query
      parameters.
        map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.
        join('&')
    end

    def url
      URI::HTTPS.build(:host  => 'www.googleapis.com',
                      :path  => '/books/v1/volumes',
                      :query => query)
    end
  end
end


