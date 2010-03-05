When /^I run [\"|\'](.*)[\"|\']$/ do |comm|
  @out = `bin/bbunny #{comm}`
end

Then /^I should see "([^\"]*)"$/ do |args|
  @out.should match(args)
end
