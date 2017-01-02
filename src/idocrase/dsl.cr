require "../idocrase"

module Idocrase::DSL
  HTTP_VERBS = %w(get post put patch delete head options)

  {% for method in HTTP_VERBS %}
    def {{method.id}}(path, &block : Idocrase::Context -> )
      router.add({{method}}.upcase, path, &block)
    end
  {% end %}

  def match(path, &block : Idocrase::Context ->)
    {% for method in HTTP_VERBS %}
      {{method.id}}(path, &block)
    {% end %}
  end

  def mount(path, app)
    path = "#{path}/" unless path.ends_with?("/")
    {% for method in HTTP_VERBS %}
      router.add({{method}}.upcase, "#{path}*#{Idocrase::Base::MOUNT_PARAM}", app)
    {% end %}
  end

  def before(path = "*", &block : Idocrase::Context -> )
    filter.add(:before, "ALL", path, &block)
  end

  {% for method in HTTP_VERBS %}
    def before_{{method.id}}(path = "*", &block : Idocrase::Context -> )
      filter.add(:before, {{method}}.upcase, path, &block)
    end
  {% end %}

  def after(path = "*", &block : Idocrase::Context -> )
    filter.add(:after, "ALL", path, &block)
  end

  {% for method in HTTP_VERBS %}
    def after_{{method.id}}(path = "*", &block : Idocrase::Context -> )
      filter.add(:after, {{method}}.upcase, path, &block)
    end
  {% end %}
end
