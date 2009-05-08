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

  before(:each) do

    @builder = Rack::Builder.new {
      use Rack::Capabilities
      use GenericMiddleware1
      use GenericMiddleware2
      use GenericMiddleware3
      use GenericMiddleware4
      use GenericMiddleware5
      run Proc.new{ |env| [200, {}, []]}
    }

    @builder.call({})
  end

  it "should find a middleware by class" do
    Rack::Capabilities.find(GenericMiddleware3).class.should == GenericMiddleware3
  end

  it "should find a middleware by proc" do
    Rack::Capabilities.find{|mw| mw.class.to_s == 'GenericMiddleware2'}.class.should == GenericMiddleware2
  end

  it "should find a middleware before" do
    Rack::Capabilities.before(Rack::Capabilities.find(GenericMiddleware3)).class.should == GenericMiddleware2
  end

  it "should find a middleware after" do
    Rack::Capabilities.after(Rack::Capabilities.find(GenericMiddleware4)).class.should == GenericMiddleware5
  end

end
