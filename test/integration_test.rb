# encoding: utf-8

require_relative 'test_helper'

class IntegrationTest < Minitest::Test
  attr_reader :clock, :formatter, :time_zone, :format

  def setup
    @clock = Time.new 2010, 1, 1, 10, 0, 0, '+00:00'

    @time_zone = 'Europe/Stockholm'
    @format = :iso8601
  end

  def formatter
    @formatter ||= Formatter::Date.new time_zone, format
  end

  def test_can_initialize_with_string
    @time_zone = 'Asia/Karachi'
    assert_equal 'Asia/Karachi', formatter.identifier
  end

  def test_can_initialize_with_tzinfo_timezone
    @time_zone = TZInfo::Timezone.get('Asia/Karachi')
    assert_equal 'Asia/Karachi', formatter.identifier
  end

  def test_fails_initialization_with_invalid_time_zone
    @time_zone = nil

    error = assert_raises ArgumentError do
      formatter
    end

    assert_includes error.message, 'nil'
  end

  def test_fails_initialization_with_invalid_format
    @format = :unknown

    error = assert_raises ArgumentError do
      formatter
    end
    assert_includes error.message, ':unknown'

    @format = 5
    error = assert_raises ArgumentError do
      formatter
    end
    assert_includes error.message, '5'
  end

  def test_identifier
    assert_equal time_zone, formatter.identifier
  end

  def test_offset
    Time.stub :now, clock do
      assert_equal Rational(1, 24), formatter.offset
    end
  end

  def test_formats_time_with_offset
    input = Time.new(2010, 1, 1, 10, 0, 0, '+00:00')
    assert_format '2010-01-01T11:00:00+01:00', input
  end

  def test_formats_datetime_with_offset
    input = DateTime.new(2010, 1, 1, 10, 0, 0, Rational(0, 24))
    assert_format '2010-01-01T11:00:00+01:00', input
  end

  def test_defaults_format_to_iso8601
    @formatter = Formatter::Date.new time_zone
    input = Time.new(2010, 1, 1, 10, 0, 0, '+00:00')

    assert_format '2010-01-01T11:00:00+01:00', input
  end

  def test_format_with_fractional_seconds
    @formatter = Formatter::Date.new time_zone, :iso8601, 2
    input = Time.new(2010, 1, 1, 10, 0, 0, '+00:00')

    assert_format '2010-01-01T11:00:00.00+01:00', input
  end

  def test_format_with_custom_string
    @format = '%Y%m%dT%H%M%S%z'
    input = Time.new(2010, 1, 1, 10, 0, 0, '+00:00')

    assert_format '20100101T110000+0100', input
  end

  %w(iso8601 xmlschema jisx0301 rfc3339).each do |format|
    define_method :"test_format_with_#{format}" do
      @format = format.to_sym

      input = DateTime.new(2010, 1, 1, 10, 0, 0, formatter.offset)

      expected = input.send(format)
      actual = formatter.format input

      assert_equal expected, actual
    end
  end

  def test_fails_formatting_with_invalid_time
    error = assert_raises ArgumentError do
      formatter.format('invalid time')
    end

    assert_includes error.message, '"invalid time"'
  end

  def assert_format(expected, input)
    Time.stub :now, clock do
      actual = formatter.format input
      assert_equal expected, actual
    end
  end
end
