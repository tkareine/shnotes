Shnotes
=======

A simple RESTful web service for storing notes, made for demonstration
purposes. It uses [Sinatra](http://www.sinatrarb.com/) as a thin application
layer between the REST interface and the database. There are two options for
the database type: [Redis](http://code.google.com/p/redis/) and
[PStore](http://www.ruby-doc.org/ruby-1.9/classes/PStore.html) (the default).

Notes are plain text, identified by their MD5 hash code. The service responds
with JSON data when a request is successful.

The following gems are required:

* contest (for tests)
* json (for Ruby 1.8)
* rack
* rack-test (for tests)
* redis (if you use it)
* sinatra
* shotgun (for development)

Usage example
-------------

Run the server:

    $ rake run:thin

Use any client that speaks HTTP, such as [cURL](http://curl.haxx.se/), to play
with the service:

    $ curl -X GET http://localhost:4567/
    {}

    $ curl -X POST http://localhost:4567/ -d note="i'm in your notes, noting"
    {"id":"6612921f3d192ac0ceaa49ccb473d456","note":"i'm in your notes, noting"}

    $ curl -X POST http://localhost:4567/ -d note="lame note"
    {"id":"83a129e12aa9375495d37fa07df0222e","note":"lame note"}

    $ curl -X GET http://localhost:4567/
    {"6612921f3d192ac0ceaa49ccb473d456":"i'm in your notes, noting","83a129e12aa9375495d37fa07df0222e":"lame note"}

    $ curl -X DELETE http://localhost:4567/83a129e12aa9375495d37fa07df0222e
    "lame note"

    $ curl -X GET http://localhost:4567/
    {"6612921f3d192ac0ceaa49ccb473d456":"i'm in your notes, noting"}

See tests for more.
