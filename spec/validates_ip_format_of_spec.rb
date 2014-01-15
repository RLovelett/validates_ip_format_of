require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Model
  include ActiveModel::Validations
  extend ValidatesIpFormatOf

  # Deprication warning
  I18n.config.enforce_available_locales = true

  attr_accessor :dhcp
  validates_ip_format_of :dhcp

  attr_accessor :dns
  validates_ip_format_of :dns

  attr_accessor :custom_ip
  validates_ip_format_of :custom_ip, :message => 'custom message'

end

describe ValidatesIpFormatOf do
  before { @model = Model.new }
  it "should allow valid IPs" do
    1000.times.each do
      begin
        ip = Faker::Internet.ip_v4_address
      end while /^10.*|^172.*|^192.168.*/.match(ip)
      @model.dhcp = ip
      @model.valid?.should be_false
      puts "#{@model.dhcp} fails validation" if @model.errors.include?(:dhcp)
      @model.errors.should_not include(:dhcp)
    end
  end

  it "should reject invalid IPs" do
    [
      nil, 1, "", " ", "url",
      "www.example.com",
      "http://ex ample.com",
      "http://ex_ample.com",
      "http://example.com/foo bar",
      'http://256.0.0.1',
      'http://u:u:u@example.com',
      'http://r?ksmorgas.com',

      # These can all be valid local URLs, but should not be considered valid
      # for public consumption.
      "http://example",
      "http://example.c",
      'http://example.toolongtld',

      # These are not real ips
      "54.5679.98.90"
    ].each do |url|
      @model.dns = url
      @model.valid?.should be_false
      @model.errors.should include(:dns)
    end
  end

  it "should require publicly routable IPv4 addresses" do
    private_ips_10 = 100.times.map { "10.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}" }
    private_ips_172 = 100.times.map { "172.#{Random.new.rand(16..31)}.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}" }
    private_ips_192 = 100.times.map { "192.168.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}" }
    reserved_ips = (private_ips_10 << private_ips_172 << private_ips_192 << "0.0.0.0" << "127.0.0.1").flatten
    reserved_ips.each do |url|
      @model.dhcp = url
      @model.valid?.should be_false
      @model.errors.should include(:dhcp)
    end
  end

  it "should override defaults" do
    @model.custom_ip = 'x'
    @model.valid?.should be_false
    @model.errors.should include(:custom_ip)
    @model.errors[:custom_ip].should include('custom message')
  end
end
