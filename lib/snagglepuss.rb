# frozen_string_literal: true

require_relative 'snagglepuss/version'

if defined?(ColorMeRad)
  if [
    :error,
    :label,
    :exclamation,
    :partition,
    :path,
    :function,
  ].all?{ |key| ColorMeRad.color_for_key(key) == :light_yellow }
    ColorMeRad.configure do |config|
      config.set_colors \
        :error => :red,
        :label => :magenta,
        :exclamation => :green,
        :path => :blue,
        :partition => :light_black,
        :function => :magenta
    end
  end
end

module Colorize
  extend self

  [
    :key,
    :data,
  ].each do |method|
    define_method method do |*args|
      return args.first.to_s unless enabled?
      ColorMeRad.send method, *args
    end
  end

  def enabled?
    return false unless defined?(ColorMeRad)
    ColorMeRad.enabled?
  end
end

module Snagglepuss
  module LineFormatter
    extend self

    def execute(line)
      return line unless Colorize.enabled?
      return Colorize.key(line, :stacktrace) unless full_match?(line)

      path, number, description = line.split(':')
      function = description.match(/`(.*)'/)[1].to_s

      '%s:%s in `%s`' % [
        Colorize.key(path, :path),
        Colorize.data(number.to_i),
        Colorize.key(function, :function),
      ]
    end

    private

    def full_match?(line)
      line.match(/[\/\w]+:\d+:in `.*'$/)
    end
  end
end

module Snagglepuss
  extend self

  class Error < StandardError; end

  SKIPPABLE_CLASSES = [
    NilClass,
    SystemExit,
  ]

  EXCLUSIONS = [
    /\/\.?asdf\//,
    /\/\.gems\//,
  ]

  def exit_stage_right(e)
    return if SKIPPABLE_CLASSES.any?{ |c| e.is_a?(c) }

    show_exception e

    $stderr.reopen(IO::NULL)
    $stdout.reopen(IO::NULL)
  end

  private

  def show_exception(e)
    exit_stage :right

    show_backtrace_for e

    puts '%s: %s' % [
      Colorize.data(e.class),
      Colorize.key(e.message, :error),
    ]

    exit_stage :left
  end

  def show_backtrace_for(e)
    #puts e.backtrace
    e.backtrace.each do |line|
      puts LineFormatter.execute(line)
    end

    puts '%s %s %s' % [
      Colorize.key('<== ', :partition),
      Colorize.key('Application trace', :label),
      Colorize.key('=' * 57 + '>', :partition),
    ]

    e.backtrace.each do |line|
      next if EXCLUSIONS.any?{ |e| line.match(e) }
      puts LineFormatter.execute(line)
    end

    puts Colorize.key('=' * 80, :partition)
  end

  def exit_stage(direction)
    exclamation = "Exit, stage #{direction}!"
    padding = 80 - (exclamation.length + 5)

    is_right = direction == :right

    fill = is_right ? '<' : '>'
    fill = Colorize.key(fill, :partition)

    puts '%s %s %s' % [
      (is_right ? fill * 3 : fill * padding),
      Colorize.key("Exit, stage #{direction}!", :exclamation),
      (is_right ? fill * padding : fill * 3),
    ]
  end

  at_exit do
    exit_stage_right $!
  end
end
