require File.dirname(__FILE__) + '/spec_helper'

describe "WillSign" do
  include WillSign
  before do
    @now = Time.utc(2007, 12, 31, 23, 58)
    Time.stub!(:now).and_return(@now)
    @hash = "1199145780:828170e4e98edc8b9d3f097695d2b0004234cb8e"
  end
  
  describe "#sign_url" do
    it "signs url with default expiry" do
      sign_url("foo/bar").should == @hash
    end
    
    it "ignores beginning slash" do
      sign_url("/foo/bar").should == @hash
    end
    
    it "ignores trailing slash" do
      sign_url("foo/bar/").should == @hash
    end
  end
  
  describe "#signed_url?" do
    it "recognizes url with hash" do
      signed_url?('foo/bar', @hash).should be_true
    end
  
    it "recognizes url with beginning slash and hash" do
      signed_url?('/foo/bar', @hash).should be_true
    end
  
    it "recognizes url with trailing slash and hash" do
      signed_url?('foo/bar/', @hash).should be_true
    end
    
    it "recognizes nearly expired hash" do
      Time.stub!(:now).and_return(@now + WillSign.default_expiry)
      signed_url?('foo/bar', @hash).should be_true
    end
    
    it "doesn't recognize expired hash" do
      Time.stub!(:now).and_return(@now + WillSign.default_expiry + 1)
      signed_url?('foo/bar', @hash).should be_false
    end
    
    it "doesn't recognize nil url" do
      signed_url?(nil, @hash).should be_false
    end
        
    it "doesn't recognize nil hash" do
      signed_url?('foo/bar', nil).should be_false
    end
    
    it "doesn't recognize blank hash" do
      signed_url?('foo/bar', '').should be_false
    end
  end

  def sign_secret() :monkey end
end