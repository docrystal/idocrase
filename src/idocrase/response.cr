require "http/server/response"
require "../idocrase"

class Idocrase::Response
  getter original : HTTP::Server::Response

  def initialize(@original)
  end

  forward_missing_to original
end
