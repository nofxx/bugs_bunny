
Given /^a queue "([^\"]*)" with (\d+) messages$/ do |name, n|
  Given "I run \"queues new #{name}\""
  n.to_i.times do |i|
    Given "I run \"queue #{name} add Message#{i}\""
  end
end

Given /^a queue "([^\"]*)"$/ do |name|
  Given "I run \"queues new #{name}\""
end

Given /^I have no queues$/ do
  Given 'I run "queues delete"'
end

Then /^I should have (\d+) queues*$/ do |n|
  Given 'I run "queues"'
  @out.split("\n").length.should eql(n.to_i+6) #table adds 6 lines
end
