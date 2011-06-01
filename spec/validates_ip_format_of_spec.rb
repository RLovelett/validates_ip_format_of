# encoding: utf-8
require 'rubygems'
require 'test/unit'
require 'active_record'
require "#{File.expand_path(File.dirname(__FILE__))}/../init.rb"

class Model
  begin  # Rails 3
    include ActiveModel::Validations
    rescue NameError  # Rails 2.*
    # ActiveRecord validations without database
    # Thanks to http://www.prestonlee.com/archives/182
    def save() end
    def save!() end
    def new_record?() false end
    def update_attribute() end  # Needed by Rails 2.1.
    def self.human_name() end
    def self.human_attribute_name(_) end
    def initialize
      @errors = ActiveRecord::Errors.new(self)
      def @errors.[](key)  # Return errors in same format as Rails 3.
        Array(on(key))
      end
    end
    def self.self_and_descendants_from_active_record() [self] end
    def self.self_and_descendents_from_active_record() [self] end  # Needed by Rails 2.2.
    include ActiveRecord::Validations
  end

  extend ValidatesIpFormatOf

  attr_accessor :dhcp
  validates_url_format_of :dhcp

  attr_accessor :dns
  validates_url_format_of :dns

  attr_accessor :custom_ip
  validates_url_format_of :custom_ip, :message => 'custom message'
end

class ValidatesUrlFormatOfTest < Test::Unit::TestCase

  def setup
    @model = Model.new
  end

  def test_should_allow_valid_ips
    1000.times.each do
      @model.dhcp = Faker::Internet.ip_v4_address
      @model.valid?
      assert @model.errors[:dhcp].empty?, "#{url.inspect} should have been accepted"
    end
  end

  def test_should_reject_invalid_urls
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
      @model.valid?
      assert !@model.errors[:dns].empty?, "#{url.inspect} should have been rejected"
    end
  end

  def test_require_publicly_routeable_ip4_addresses
    private_ips_10 = 100.times.map { "http://10.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}" }
    private_ips_172 = 100.times.map { "http://172.#{Random.new.rand(16..31)}.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}" }
    private_ips_192 = 100.times.map { "http://192.168.#{Random.new.rand(0..255)}.#{Random.new.rand(0..255)}" }
    reserved_ips = (private_ips_10 << private_ips_172 << private_ips_192 << "http://0.0.0.0" << "http://127.0.0.1").flatten
    reserved_ips.each do |url|
      @model.dhcp = url
      @model.valid?
      assert !@model.errors[:dhcp].empty?, "#{url.inspect} should have been rejected"
    end
  end

  def test_can_override_defaults
    @model.custom_ip = 'x'
    @model.valid?
    assert_equal ['custom message'], @model.errors[:custom_ip]
  end

end
