GoogleBooks
===========

GoogleBooks is a lightweight wrapper for Google Book Search on Rails. It is inspired by the [google-book](https://github.com/papercavalier/google-book) gem which relies on the deprecated [Google Book Search Data API](http://code.google.com/apis/books/docs/gdata/developers_guide_protocol.html), but is updated to hook into the current Google API.

Queryable Attributes
--------------------

By default, GoogleBooks can query the following attributes:

* `title`
* `authors` (returns all authors as a comma delimited string)
* `publisher`
* `published_date`
* `description`
* `isbn` (tries to return 13-digit first, then 10-digit, then nil)
* `isbn_10` (returns 10-digit form only)
* `isbn_13` (returns 13-digit form only)
* `page_count`
* `print_type`
* `categories` (returns all categories as a comma delimited string)
* `average_rating`
* `ratings_count`
* `language`
* `preview_link`
* `info_link`

GoogleBooks also returns the `image_link` to the book's cover image, if available:

* `image_link({options_hash})`
	Options hash arguments:
	`:curl`: pass true to return image_url of cover with curled corner (default = false)
	`:zoom`: pass numeric value between 1-7 to the zoom attribute (default = 1)

=== Support for distributed clustering

The current Google API for Books generally requires that a users IP address be geolocatable. This can cause responses to be restricted when requested from distributed/clustered servers such as Heroku.

http://www.google.com/support/forum/p/booksearch-apis/thread?tid=2034bed9a98c15cb&hl=en

GoogleBooks can circumvent these issues by adding an X-Forwarded-For HTTP header to each request that contains the IP address of the user. In most cases, you can pass the user's IP address as a parameter in your search request:

  GoogleBooks.search("Search Query", {options}, request.remote_ip)

Doing this will, for the most part, enable you to query the Google API from apps that reside on Heroku servers.

=== ISBN

ISBN numbers come in two varieties: 10-digit and 13-digits. Most books possess both versions.

Gbook can be configured to an return either ISBN, but attempts to return the 13-digit version by default. If the 13-digit version cannot be found, GoogleBooks tries the 10-digit version, and finally returns nil.

=== Image links

When possible, GoogleBooks will return links to an image of a book's cover. The size of this image is configurable by passing an numerical argument between 1-7 to the image_link attribute, which is passed to the zoom attribute in the URL query.

  book = GoogleBooks.search("The Great Gatsby").first
  book.image_link(1) # link to a medium sized image
  book.image_link(5) # link to a thumbnail sized image
  book.image_link(7) # link to a large sized image
  
This enables you to manipulate and cull different sized images on the fly without cluttering the codebase with overly verbose methods.

=== Examples

  Here are some examples that you can use
  
