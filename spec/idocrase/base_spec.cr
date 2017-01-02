require "../spec_helper"

class SpecApp < Idocrase::Base
end

describe Idocrase::Base do
  describe ".config" do
    it "should have unique config instance" do
      Idocrase::Base.config.object_id.should_not eq(SpecApp.config.object_id)
      Idocrase::Base.config.object_id.should eq(Idocrase::Base.config.object_id)
    end
  end

  describe ".configure" do
    it "should configure app" do
      SpecApp.configure do |c|
        c.host = "example.com"
      end

      SpecApp.config.host.should eq("example.com")
    end
  end
end
