require "http/request"
require "http/server/response"
require "../idocrase"

class Idocrase::Context
  getter context : HTTP::Server::Context
  getter request : Idocrase::Request
  getter response : Idocrase::Response
  property params : Hash(String, String)
  property filter_params : Hash(String, String)
  property config : Idocrase::Config

  delegate logger, to: config

  def initialize(@config, @context : HTTP::Server::Context)
    @request = Idocrase::Request.new(@context.request)
    @response = Idocrase::Response.new(@context.response)
    @params = {} of String => String
    @filter_params = {} of String => String
  end

  def error(status_code, message)
    response.status_code = status_code
    response.content_type = "text/plain"
    response.print(message)
  end
end
