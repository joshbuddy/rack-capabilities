class Rack::Builder
  def use(middleware, *args, &block)
    @capabilities ||= []
    @ins << lambda { |app|
      mw = middleware.new(app, *args, &block)
      @capabilities.unshift(mw)
      mw.list = @capabilities if Rack::Capabilities === mw
      mw
    }
  end
end

module Rack

  class Capabilities

    attr_accessor :list

    def initialize(app)
      @app = app
      @list = []
    end

    def call(env)
      env['rack.capabilities'] = self
      @app.call(env)
    end

    def each(&block)
      list.each {|app| block.call(app) }
    end

    def find(clazz = nil, &block)
      clazz ? list.find { |mw| clazz === mw } : list.find(&block)
    end

    def before(mw, distance = 1)
      relative(mw, -distance)
    end

    def after(mw, distance = 1)
      relative(mw, distance)
    end

    def relative(mw, pos)
      index = list.index(mw)
      index ? list[index + pos] : nil
    end

  end

end
