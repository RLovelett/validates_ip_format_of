# validates\_ip\_format\_of [![Build Status](https://travis-ci.org/RLovelett/validates_ip_format_of.png?branch=master)](https://travis-ci.org/RLovelett/validates_ip_format_of) [![Gem Version](https://badge.fury.io/rb/validates_ip_format_of.png)](http://badge.fury.io/rb/validates_ip_format_of)

Rails plugin that provides a `validates_ip_format_of` method to `ActiveRecord` models. IPs are validated by regexp.

## Support

Tests are run on all versions listed.

### Rubies

  * `1.9.3`
  * `2.0.0`
  * `2.1.0`
  * `head`

### ActiveRecord

  * `~> 3.0.0`
  * `~> 3.1.0`
  * `~> 3.2.0`
  * `~> 4.0.0`
  * `master`

## Usage

After installing the plugin, it's used like

```ruby
class User < ActiveRecord::Base
  validates_ip_format_of :dhcp,
                         :allow_nil => true,
                         :message => 'is completely unacceptable'
end
```

Takes the same arguments as
[`validates_format_of`](http://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#M001052)
except for the `:with` regexp.

Please note that the regexp used to validate IPs is not perfect, but
hopefully good enough. See the test suite. Patches are very welcome.

## Limitations and design choices

Does not handle IPv6.

By design, the plugin does not allow RFC 1918 IPv4 addresses, e.g.,
10.0.0.0, 172.16.0.0, 192.168.0.0, from being input. Also, prevents
127.0.0.1 and 0.0.0.0.

## Credits and license

Based on my contributions made to
[`validates_url_format_of`](https://github.com/henrik/validates_url_format_of)
written by [Henrik Nyh](https://github.com/henrik), which is also
released under the MIT license.

See LICENSE.md
