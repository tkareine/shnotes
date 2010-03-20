Shnotes
=======

A simple RESTful web service for storing notes, made for demonstration
purposes. It uses [Sinatra](http://www.sinatrarb.com/) and
[PStore](http://www.ruby-doc.org/ruby-1.9/classes/PStore.html).

Notes are plain text, identified by their MD5 hash code. The service responds
with JSON data when a request is successful.

Usage example
-------------

Run the server:

    $ rake run:thin

Use any client that speaks HTTP, such as
[rest-client](http://rdoc.info/projects/archiloque/rest-client), to play
with the service:

    $ restclient http://localhost:4567

    > get('/').body
    # => "{}"
    > post('/', {:note => "zomg"}).body
    # => "{\"id\":\"22487fae2a1d945fdee78f72524fe263\",\"note\":\"zomg\"}"
    > get('/').body
    # => "{\"22487fae2a1d945fdee78f72524fe263\":\"zomg\"}"
    > delete('/22487fae2a1d945fdee78f72524fe263').body
    # => "\"zomg\""
    > get('/').body
    # => "{}"

See tests for more.
