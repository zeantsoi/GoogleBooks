GoogleBooks
===========

GoogleBooks is a lightweight Ruby wrapper that queries the Google API to search for publications in the Google Books repository.

It is inspired by the [google-book](https://github.com/papercavalier/google-book) gem which relies on the deprecated [Google GData Books API](http://code.google.com/apis/books/docs/gdata/developers_guide_protocol.html), but is updated to hook into the current Google API and expanded to provide additional methods and search options.

Basic Usage
-----------

Using GoogleBooks is simple. There's just one class, `GoogleBooks`, and one method, `search`. Queries return an enumerable collection of results, each with their own set of attributes that can be individually configured.

    require 'googlebooks' # unless you're using Bundler
    
    books = GoogleBooks.search('The Great Gatsby')
    first_book = book.first
    
    first_book.author #=> 'F. Scott Fitzgerald'
    first_book.isbn #=> '9781443411080'
    first_book.image_link(:zoom => 6) #=> 'http://bks2.books.google.com/books?id=...'
    

Options Hash
-----------

The `search` method allows for an options hash of up to four parameters. These parameters are `page`, `count`, `order_by`, and `api_key`. Necessity of a Google API key is application dependent; further information is available in [Google's API documentation](http://code.google.com/apis/books/docs/v1/using.html).

    require 'googlebooks'
    
    GoogleBooks.search('The Great Gatsby', {:count => 10}) 
    #=> returns first ten results (default = 5)
   
    GoogleBooks.search('The Great Gatsby', {:page => 2}) 
    #=> returns second page of results (default = 1)
    
    GoogleBooks.search('The Great Gatsby', {:count => 3, :page => 4, :api_key => 'THIS_IS_YOUR_API_KEY'}) 
    #=> returns three results, beginning with the 10th overall result

By default, results are returned in order of relevance. However, results also be ordered from most recently to least recently published by passing `newest` to the `order_by` key. Passing anything other than `newest` will return results by relevance. Google [does not currently support](https://groups.google.com/a/googleproductforums.com/forum/#!searchin/books/publication$20date/books/wKuq9TLGYsc/SRIk-YiiPHQJ) querying any values other than `relevance` and `newest`.

    GoogleBooks.search('The Great Gatsby', {:order_by => 'newest'})
    #=> returns results in order of most recently to least recently published
    
    GoogleBooks.search('The Great Gatsby')
    GoogleBooks.search('The Great Gatsby', {:order_by => `ANYTHING ELSE`})
    #=> both return results in order of relevance

Special Keywords
----------------

There are special keywords you can specify in the search terms to search in particular fields, such as:

* `intitle` *Returns results where the text following this keyword is found in the title.*
* `inauthor` *Returns results where the text following this keyword is found in the author.*
* `inpublisher` *Returns results where the text following this keyword is found in the publisher.*
* `subject` *Returns results where the text following this keyword is listed in the category list of the volume.*
* `isbn` *Returns results where the text following this keyword is the ISBN number.*

Examples:
    
    require 'googlebooks'
    
    books = GoogleBooks.search('isbn:9781443411080') # yields a collection of one result
    book = books.first # the one result
    
    book.title #=> 'The Great Gatsby'
    
Attributes
----------

By default, GoogleBooks can query the following attributes (note that not all attributes are available to all books):

* `title`
* `authors` *Returns all authors as a comma delimited string*
* `publisher`
* `published_date`
* `description`
* `isbn` *Attempts to return 13-digit first, then 10-digit, then nil*
* `isbn_10` *Returns 10-digit form only*
* `isbn_13` *Returns 13-digit form only*
* `page_count`
* `print_type`
* `categories` *Returns all categories as a comma delimited string*
* `average_rating`
* `ratings_count`
* `language`
* `preview_link`
* `info_link`
* `image_link` *See details below*

Sale and retail information is available on some volumes as of Google Books API v1. GoogleBooks returns a hash of these attributes (where available) under the `sale_info` attribute.

    book = GoogleBooks.search(9780345508553).first # Do Androids Dream of Electric Sheep?
   
    book['country'] #=> 'US'
    book['saleability'] #=> 'FOR_SALE'
    book['isEbook'] #=> true
    book['listPrice']['amount'] #=> 9.99
    book['listPrice']['currencyCode'] #=> 'USD'
    book['retailPrice']['amount'] #=> 9.99
    book['retailPrice']['currencyCode'] #=> 'USD'
    book['buyLink'] #=> 'http://books.google.com/books?id=jUX8N9kiCiQC&dq=9780345508553&buy=&source=gbs_api'
   
Note that the `sale_info` attribute is only available for some volumes and will sometimes return `nil` for nested attributes. Use with caution as GoogleBooks does not provide built-in error handling for instances of `nil`.

Image Links
-----------

When possible, GoogleBooks will return links to an image of a book's cover. The size and appearance of the cover can be configured by passing an optional hash of arguments to the attribute.

The size of this image is configurable by passing an numerical argument between 1-6 to the image_link attribute, which is passed to the zoom attribute in the URL query.

* `:zoom` *Pass numeric value between 1-6 to the zoom attribute* (default = 1)

GoogleBooks will, by default, return the image_link for an aesthetically unmodified cover. However, if you'd like Google to return an image with a "curled" corner (when available), you can pass true to this key. 

* `:curl` *Pass true to return image_link of cover with curled corner* (default = false)

Examples:
    
    book = GoogleBooks.search("The Great Gatsby").first
    
    # return image_link with default options
    book.image_link # zoom=1, edge=none
    
    # return image_link of varying sizes
    book.image_link # small
    book.image_link(:zoom => 5) # thumbnail
    book.image_link(:zoom => 2) # medium
    book.image_link(:zoom => 3) # large
    book.image_link(:zoom => 4) # extra large
    
    # return image_link with curled corners
    book.image_link(:curl => true)
    
    # return thumbnail image_link with curled corners
    book.image_link(:zoom => 5, :curl => true)
  
Support for distributed production servers
------------------------------------------

The current Google API for Books generally requires that the requesting server's IP address be geolocatable. [This can cause responses to be restricted](http://www.google.com/support/forum/p/booksearch-apis/thread?tid=2034bed9a98c15cb&hl=en) when requested from distributed/clustered servers such as Heroku.

GoogleBooks can resolve these issues by adding an X-Forwarded-For HTTP header to each request that contains the IP address of the user. In most cases, you can pass the user's IP address as the third parameter in your search request:

    # Request made from Heroku server without passing user's IP address to HTTP header
    GoogleBooks.search("Search Query", {options_hash}) #=> returns error hash
    
    # Request made from Heroku server with user's IP address
    user_ip = request.remote_ip # assuming user is accessing from a valid IP address
    GoogleBooks.search("Search Query", {options_hash}, user_ip) #=> returns valid hash of results

Doing this will, for the most part, enable you to query the Google API from apps that reside across distributed nodes.

Etcetera
--------

GoogleBooks is licensed under the GNU GPL. Modify and distribute freely.

Please feel free to contact the developer with any questions or suggestions. Forking and merge/pull requests are encouraged for those who would like to take part in improving this gem.

