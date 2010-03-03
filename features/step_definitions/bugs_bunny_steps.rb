When /^I run "([^\"]*)"$/ do |comm|
  @cmd = `bin/bbunny #{comm}`
end

Then /^I should see "([^\"]*)"$/ do |args|
  @cmd.should match(args)
end
