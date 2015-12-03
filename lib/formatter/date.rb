# encoding: utf-8

require 'tzinfo'
require 'delegate'

module Formatter
  # Date formatter with time zone support.
  class Date
    # Wrapper class around TZInfo::TimeOrDateTime that only accepts
    # Time or DateTime.
    class TimeOrDateTime < DelegateClass(TZInfo::TimeOrDateTime)
      def initialize(object)
        case object
        when Time
          object = object.utc
        when DateTime
          object = object.new_offset Rational(0, 24)
        else
          fail ArgumentError, "invalid Time or DateTime: #{object.inspect}"
        end

        super TZInfo::TimeOrDateTime.wrap(object)
      end
    end

    # Initialize a formatter with the desired options.
    #
    # :time_zone specifies which time zone to use when formatting.
    #
    # :format specifies which format to use, it can either be a symbol of a
    # predefined format or a string with a custom format which will be
    # delegated to DateTime#strftime.
    #
    # :fraction is length of fractional seconds to be used with predefined
    # formats.
    #
    # @param [String|TZInfo::Timezone] time_zone
    # @param [Symbol|String] format
    # @param [Integer] fraction (0)
    #
    # @return [undefined]
    #
    # @api public
    def initialize(time_zone, format = :iso8601, fraction = 0)
      self.time_zone = time_zone
      @formatter = formatter_for format, fraction
    end

    # Format Time or DateTime with formatter
    #
    # @param [Time|DateTime] time_or_datetime
    #
    # @return [String]
    #
    # @api public
    def format(time_or_datetime)
      formatter.call with_offset(time_or_datetime)
    end

    # Configured time zone identifier
    #
    # @return [String]
    #
    # @api public
    def identifier
      time_zone.identifier
    end

    # Configured time zone offset
    #
    # @return [Rational]
    #
    # @api public
    def offset
      time_zone.current_period.utc_total_offset_rational
    end

    private

    attr_reader :time_zone, :formatter

    def time_zone=(time_zone)
      case time_zone
      when String
        @time_zone = TZInfo::Timezone.get time_zone
      when TZInfo::DataTimezone
        @time_zone = time_zone
      else
        fail ArgumentError, "invalid time zone: #{time_zone.inspect}"
      end
    end

    def formatter_for(format, fraction)
      case format
      when Symbol
        if format_method? format
          return ->(datetime) { datetime.send format, fraction }
        end
      when String
        return ->(datetime) { datetime.strftime format }
      end

      fail ArgumentError, "invalid value for format: #{format.inspect}"
    end

    def format_method?(method)
      %w(iso8601 xmlschema jisx0301 rfc3339).include? method.to_s
    end

    def with_offset(time_or_datetime)
      TimeOrDateTime.new(time_or_datetime).to_datetime.new_offset offset
    end
  end
end
