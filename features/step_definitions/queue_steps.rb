

Given /^a queue "([^\"]*)" with (\d+) messages$/ do |name, n|
  AMQP.start(@opts) do
    n.to_i.times { |i| MQ.queue(name).publish("Message #{i}") }
    EM.stop_event_loop
  end
end


