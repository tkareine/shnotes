$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), "lib"))
require "shnotes/app"

run Shnotes::App
