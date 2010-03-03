require File.dirname(__FILE__) + "/../spec_helper"

describe BugsBunny::CLI do

  it "should call itself it has the method" do
    File.should_receive(:exists?).with("config/").and_return(false)
    File.should_receive(:exists?).with("./rabbitmq.yml").and_return(false)
    File.should_receive(:copy).and_return(true)
    BugsBunny::CLI.new(["config"])
  end

  it "should not overwrite config file" do
    File.should_receive(:exists?).with("config/").and_return(false)
    File.should_receive(:exists?).with("./rabbitmq.yml").and_return(true)
    File.should_not_receive(:copy)
    BugsBunny::CLI.new(["config"])
  end

end
