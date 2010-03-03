require File.dirname(__FILE__) + "/../spec_helper"

describe BugsBunny::Rabbit do

  it "should find vhosts" do
    @rb = BugsBunny::Rabbit.new
    @rb.should_receive(:"`").with("rabbitmqctl list_vhosts").and_return("foo")
    @rb.should_receive(:halt)
    @rb.vhosts
  end

end
