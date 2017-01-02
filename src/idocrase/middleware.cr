require "../idocrase"

abstract class Idocrase::Middleware
  include Idocrase::Handler

  abstract def call(context)
end

require "./middleware/*"
