require 'version'
require 'book/response'

require 'httparty'
require 'cgi'

module GoogleBooks

  include HTTParty
  # Don't verify SSL certificate - as it's not valid
  default_options.update(verify: false)

  format :json

  class << self

    attr_accessor :parameters

    # Submits query to the current Google API for Books.
    #
    # 1st param passes all varieties of acceptable query strings
    #
    # 2nd param passes options hash:
    # * :count passes number of results to display per page (default=5)
    # * :page passes the page number (default=1)
    # * :api_key passes the application specific Google API key
    #
    # 3rd parameter optionally passes user's IP address
    # * User IP may be require in order for request to be made to the
    #   Google API from applications residing on decentralized cloud servers
    #   See http://www.google.com/support/forum/p/booksearch-apis/thread?tid=2034bed9a98c15cb&hl=en

    def search(query, options = {}, remote_ip = nil)
      (headers 'X-Forwarded-For' => remote_ip.to_s) unless remote_ip.nil?
      self.parameters = { 'q' => query }
      options[:page] ||= 1
      options[:count] ||= 5
      parameters['filter'] = options[:filter] if options[:filter]
      parameters['startIndex'] = options[:count] * (options[:page] - 1)
      parameters['maxResults'] = options[:count]
      parameters['key'] = options[:api_key] if options[:api_key]
      parameters['orderBy'] = 'newest' if options[:order_by].eql?('newest')
      parameters['country'] = options[:country] if options[:country]

      Response.new(get(url.to_s))
    end

    private

    def query
      parameters.
        map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.
        join('&')
    end

    # Queries the new Google API. The former Google Book Search API is deprecated
    # http://code.google.com/apis/books/docs/gdata/developers_guide_protocol.html
    def url
      URI::HTTPS.build(:host  => 'www.googleapis.com',
                      :path  => '/books/v1/volumes',
                      :query => query)
    end
  end
end


