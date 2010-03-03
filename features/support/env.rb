$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'bugs_bunny'

require 'spec/expectations'

Before do
  @opts = { :host => "localhost" }
end
