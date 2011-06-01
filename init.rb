require 'active_record'

# encoding: utf-8
module ValidatesIpFormatOf
  IPv4_PART = /\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]/  # 0-255

  # http://en.wikipedia.org/wiki/IP_address
  # http://en.wikipedia.org/wiki/Default_route
  # http://en.wikipedia.org/wiki/Localhost

  # Blocks IPv4 10.0.0.0 - 10.255.255.255
  TWENTY_FOUR_BIT_BLOCK = /(?!10\.((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.?)){3})/
  # Blocks IPv4 172.16.0.0 - 172.31.255.255
  TWENTY_BIT_BLOCK      = /(?!172\.(0?3[0-1]|0?2[0-9]|0?1[6-9])\.((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.?)){2})/
  # Blocks IPv4 192.168.0.0 - 192.168.255.255
  SIXTEEN_BIT_BLOCK     = /(?!192\.168\.((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.?)){2})/
  # Blocks IPv4 127.0.0.1 (which is also localhost)
  LOCALHOST_LOOPBACK    = /(?!127\.0\.0\.[0-8])/
  ALL_ROUTES            = /(?!0\.0\.0\.0)/
  RFC_1918_IPS          = %r{#{TWENTY_FOUR_BIT_BLOCK}#{TWENTY_BIT_BLOCK}#{SIXTEEN_BIT_BLOCK}}

  REGEXP = %r{
    \A
    #{LOCALHOST_LOOPBACK}                                              # blocks 127.0.0.0/8
    #{ALL_ROUTES}                                                      # blocks 0.0.0.0
    #{RFC_1918_IPS}                                                    # blocks the use of RFC 1918 private network IPv4 addresses
    #{IPv4_PART}(\.#{IPv4_PART}){3}                                    # Allow IPv4
    \Z
  }iux

  DEFAULT_MESSAGE = 'does not appear to be a valid IP Address'

  def validates_ip_format_of(*attr_names)
    options = { :allow_nil => false,
                :allow_blank => false,
                :message => DEFAULT_MESSAGE,
                :with => REGEXP
    }
    options = options.merge(attr_names.pop) if attr_names.last.is_a?(Hash)
    attr_names.each do |attr_name|
      validates_format_of(attr_name, options)
    end
  end

end

ActiveRecord::Base.extend(ValidatesIpFormatOf)
