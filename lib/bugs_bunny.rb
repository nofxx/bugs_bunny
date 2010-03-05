#
# O que que ha, velhinho?
#
begin
  require "nanite"
rescue LoadError
  require "amqp"
  require "mq"
end

module BugsBunny
  Opt = {:verbose => false, :force => false, :rabbit => {}, :mode => :marshal}
end

require "bugs_bunny/helper"
require "bugs_bunny/cli"
require "bugs_bunny/rabbit"
require "bugs_bunny/queue"
require "bugs_bunny/exchange"
