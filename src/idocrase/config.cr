require "logger"
require "../idocrase"

class Idocrase::Config
  property host : String
  property port : Int32
  property logger : Logger

  def initialize
    @host = "0.0.0.0"
    @port = 3000
    @logger = Logger.new(STDOUT)
  end
end
