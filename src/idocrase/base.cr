require "http/server"
require "../idocrase"
require "./dsl"
require "./handler"

class Idocrase::Base
  include HTTP::Handler
  include Idocrase::Handler
  extend Idocrase::DSL

  MOUNT_PARAM = "__idocrase_mounted_path"

  @app : Idocrase::Handler | Nil

  def self.config : Config
    @@config ||= Config.new
  end

  def self.configure(&block : Config ->)
    yield config
  end

  def self.filter
    @@filter ||= Filter.new
  end

  def self.router
    @@router ||= Router.new
  end

  def self.middlewares
    @@middlewares ||= [] of Middleware
  end

  def self.handlers
    @@handlers ||= [] of HTTP::Handler
  end

  def self.use(middleware : Middleware)
    middlewares.push(middleware)
  end

  def self.use(handler : HTTP::Handler)
    handlers.push(handler)
  end

  def self.run
    handlers.push(new)
    _handlers = HTTP::Server.build_middleware(handlers)

    server = HTTP::Server.new(config.host, config.port, _handlers)
    server.listen
  end

  def call(context : HTTP::Server::Context)
    ctx = Idocrase::Context.new(self.class.config, context)
    call(ctx)
  end

  def call(context : Idocrase::Context)
    mounted_path = context.params.fetch(MOUNT_PARAM, nil)
    if mounted_path
      context.params.delete(MOUNT_PARAM)
      context.request.path = "/#{mounted_path}"
    end
    app.call(context) || call_next(context)
  end

  private def app : Idocrase::Handler
    @app ||= begin
      unless self.class.middlewares.empty?
        self.class.middlewares.each_with_index do |middleware, idx|
          next if idx == 0
          self.class.middlewares[idx - 1].next_handler = middleware
        end
        self.class.middlewares.last.next_handler = self.class.filter
      end
      self.class.filter.next_handler = self.class.router

      self.class.middlewares.first? || self.class.filter
    end
  end
end
