require "radix"
require "../idocrase"

class Idocrase::Router
  include Idocrase::Handler

  getter routes

  def initialize
    @routes = Radix::Tree(Idocrase::Handler | Idocrase::Handler::Proc).new
  end

  def add(method, path, &block : Idocrase::Handler::Proc)
    add(method, path, block)
  end

  def add(method, path, handler)
    path = "/#{path}" unless path.starts_with?("/")
    routes.add(radix_path(method, path), handler)
  rescue Radix::Tree::DuplicateError
    raise ArgumentError.new("#{method} #{path} is already defined")
  end

  def call(context)
    request = context.request
    result = routes.find(radix_path(request.method, request.path))

    if result.found?
      context.params = result.params
      result.payload.call(context)
      true
    else
      false
    end
  end

  private def radix_path(method, path)
    "#{method}#{path}"
  end
end
