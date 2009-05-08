require 'spec_helper'

GenericMiddleware = Class.new do
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end
end

GenericMiddleware1 = Class.new(GenericMiddleware)
GenericMiddleware2 = Class.new(GenericMiddleware)
GenericMiddleware3 = Class.new(GenericMiddleware)
GenericMiddleware4 = Class.new(GenericMiddleware)
GenericMiddleware5 = Class.new(GenericMiddleware)

describe "Rack Capabilities" do

  def app(&block)
    @builder = Rack::Builder.new {
      use Rack::Capabilities
      use GenericMiddleware1
      use GenericMiddleware2
      use GenericMiddleware3
      use GenericMiddleware4
      use GenericMiddleware5
      run lambda { |env| block[env]; [200, {}, []] }
    }

    @builder.call({})
  end

  it "should find a middleware by class" do
    app do |env|
      env['rack.capabilities'].find(GenericMiddleware3).class.should == GenericMiddleware3
    end
  end

  it "should find a middleware by proc" do
    app do |env|
      env['rack.capabilities'].find{|mw| mw.class.to_s == 'GenericMiddleware2'}.class.should == GenericMiddleware2
    end
  end

  it "should find a middleware before" do
    app do |env|
      env['rack.capabilities'].before(env['rack.capabilities'].find(GenericMiddleware3)).class.should == GenericMiddleware2
    end
  end

  it "should find a middleware after" do
    app do |env|
      env['rack.capabilities'].after(env['rack.capabilities'].find(GenericMiddleware4)).class.should == GenericMiddleware5
    end
  end

end
