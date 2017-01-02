require "../exception"

class Idocrase::Exception::InvalidRouteException < Idocrase::Exception
  def initialize(methods, path)
    super "Route declaration #{methods.join(", ")} \"#{path}\" needs to start with '/', should be #{methods.join(", ")} \"/#{path}\""
  end
end
