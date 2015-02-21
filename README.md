# formatter-date

Format Time/DateTime with time zone offset

[![Gem Version](https://badge.fury.io/rb/formatter-date.svg)](http://badge.fury.io/rb/formatter-date)
[![Build
Status](https://travis-ci.org/terlar/formatter-date.svg)](https://travis-ci.org/terlar/formatter-date)
[![Code Climate](https://codeclimate.com/github/terlar/formatter-date.png)](https://codeclimate.com/github/terlar/formatter-date)

## Installation

Add this line to your application's Gemfile:

    gem 'formatter-date'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install formatter-date

## Usage

```ruby
# By default it will use the ISO8601 formatting.
formatter = Formatter::Date.new('Asia/Karachi')
formatter.format(Time.now) # "2015-02-22T03:48:07+05:00"

# Available formats iso8601, xmlschema, jisx0301, rfc3339
formatter = Formatter::Date.new('Asia/Karachi', :jisx0301)
formatter.format(Time.now) # "H27.02.22T03:48:07+05:00"

# You can also provide fractional seconds to be used with formats
formatter = Formatter::Date.new('Asia/Karachi', :iso8601, 2)
formatter.format(Time.now) # 2015-02-22T03:48:07.46+05:00

# Provide a custom string formatting (delegates to strftime)
formatter = Formatter::Date.new('Asia/Karachi', '%FT%T%:z')
formatter.format(Time.now) # "2015-02-22T03:48:07+05:00"

# Get configured time zone identifier
formatter.identifier # "Asia/Karachi"

# Get configured time zone offset
formatter.offset # (5/24)
```

## Contributing

1. Fork it ( https://github.com/terlar/formatter-date/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
