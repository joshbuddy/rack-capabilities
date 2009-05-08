class Rack::Builder

  def use(middleware, *args, &block)
    @ins << lambda { |app|
      mw = middleware.new(app, *args, &block)
      Rack::Capabilities.ins.unshift(mw)
      mw
    }
  end

end

module Rack

  class Capabilities

    @@ins = []

    def self.ins
      @@ins
    end

    def self.find(cls = nil, &block)
      cls ? ins.find{|mw| cls === mw} : ins.find(&block)
    end

    def self.before(mw, distance = 1)
      relative(mw, -distance)
    end

    def self.after(mw, distance = 1)
      relative(mw, distance)
    end

    def self.relative(mw, pos)
      index = ins.index(mw)
      index ? ins[index + pos] : nil
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end

  end

end
