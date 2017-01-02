require "http/request"
require "../idocrase"

class Idocrase::Request
  getter original : HTTP::Request

  def initialize(@original)
  end

  forward_missing_to original
end
