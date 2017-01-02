require "radix"
require "../idocrase"

class Idocrase::Filter
  include Idocrase::Handler

  getter :filters

  def initialize
    @filters = Radix::Tree(Array(Idocrase::Handler | Idocrase::Handler::Proc)).new
  end

  def add(timing, method, path, &handler : Idocrase::Handler::Proc)
    path = "/#{path}" unless path.starts_with?("/")
    rpath = radix_path(timing, method, path)

    result = filters.find(rpath)
    if result.found?
      result.payload.push(handler)
    else
      filters.add(rpath, [handler] of Idocrase::Handler | Idocrase::Handler::Proc)
    end
  end

  def call(context)
    method = context.request.method
    path = context.request.path
    call_filter(:before, "ALL", path, context)
    call_filter(:before, method.upcase, path, context)
    ret = call_next(context)
    call_filter(:after, method.upcase, path, context)
    call_filter(:after, "ALL", path, context)
    ret
  end

  private def call_filter(timing, method, path, context)
    result = filters.find(radix_path(timing, method, path))
    if result.found?
      context.filter_params = result.params
      result.payload.each do |handler|
        handler.call(context)
      end
    end
  end

  private def radix_path(timing, method, path)
    "#{timing}/#{method}#{path}"
  end
end
