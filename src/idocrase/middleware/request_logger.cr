require "time"
require "../middleware"

class Idocrase::Middleware::RequestLogger < Idocrase::Middleware
  def call(context)
    res = context.response
    method = context.request.method
    path = context.request.path

    before = Time.now
    call_next(context)
    after = Time.now
    duration = after - before

    context.logger.info("#{method} #{path} #{res.status_code} #{elapsed_text duration}")
  end

  private def elapsed_text(elapsed)
    minutes = elapsed.total_minutes
    return "#{minutes.round(2)}m" if minutes >= 1

    seconds = elapsed.total_seconds
    return "#{seconds.round(2)}s" if seconds >= 1

    millis = elapsed.total_milliseconds
    return "#{millis.round(2)}ms" if millis >= 1

    "#{(millis * 1000).round(2)}µs"
  end
end
