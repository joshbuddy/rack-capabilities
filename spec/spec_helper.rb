require 'spec'
require 'rubygems'
require 'rack'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/capabilities'

Spec::Runner.configure do |config|

end
