require "../idocrase"

module Idocrase::Handler
  abstract def call(context : Idocrase::Context)

  property next_handler : Idocrase::Handler | Idocrase::Handler::Proc | Nil

  def call_next(context)
    if next_handler = @next_handler
      next_handler.call(context)
    else
      context.error(404, "Not Found")
    end
  end

  alias Proc = Idocrase::Context ->
end
