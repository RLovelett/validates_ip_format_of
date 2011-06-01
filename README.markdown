# validates\_ip\_format\_of

Rails plugin that provides a `validates_ip_format_of` method to `ActiveRecord` models. IPs are validated by regexp.

Known to be compatible with Ruby 1.9.2.

Known to be compatible with ActiveRecord 3.0.7.


## Usage

After installing the plugin, it's used like

    class User < ActiveRecord::Base
      validates_ip_format_of :dhcp,
                              :allow_nil => true,
                              :message => 'is completely unacceptable'
    end

Takes the same arguments as [`validates_format_of`](http://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#M001052) except for the `:with` regexp.

Please note that the regexp used to validate IPs is not perfect, but hopefully good enough. See the test suite. Patches are very welcome.

## Limitations and design choices

Does not handle IPv6.

By design, the plugin does not allow RFC 1918 IPv4 addresses, e.g., 10.0.0.0, 172.16.0.0, 192.168.0.0, from being input. Also, prevents 127.0.0.1 and 0.0.0.0.

## Credits and license

Based on my contributions made to `validates_url_format_of` written by [Henrik Nyh](https://github.com/henrik/validates_url_format_of), which is also released under the MIT license.

By [Ryan Lovelett](http://www.wahvee.com/) under the MIT license:

>  Copyright (c) 2011 Ryan Lovelett
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
