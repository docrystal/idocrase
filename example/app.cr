require "../src/idocrase"

class MountedApp < Idocrase::Base
  get "/" do |c|
    c.response.content_type = "text/plain"
    c.response.print "This is mounted app"
  end
end

class MyApp < Idocrase::Base
  # You can configure application
  configure do |config|
    config.port = 3000
  end

  # You can use middleware with HTTP::Handler
  use HTTP::DeflateHandler.new
  # You can use middleware with Idocrace::Middleware
  use Idocrase::Middleware::RequestLogger.new

  before "/:path/*" do |c| # after
    c.logger.info("before filter: #{c.filter_params["path"]?}")
  end

  before_get do |c| # or after_*
    c.logger.info("THIS IS GET REQUEST!!")
  end

  # Mountable other idocrase applications!
  mount "/mounted", MountedApp.new

  get "/" do |c|
    c.response.content_type = "text/plain"
    c.response.print "This is example\n"
  end

  get "/hello/:name" do |c|
    c.response.content_type = "text/plain"
    c.response.print "Hello, #{c.params["name"]}\n"
  end
end

MyApp.run
