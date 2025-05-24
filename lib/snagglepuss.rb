# frozen_string_literal: true

require_relative "snagglepuss/version"

if defined?(ColorMeRad)
  if ColorMeRad.color_for_key(:error) == :light_yellow &&
      ColorMeRad.color_for_key(:label) == :light_yellow
    ColorMeRad.configure do |config|
      config.set_colors \
        :error => :red,
        :label => :magenta
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
      return args.first.to_s unless defined?(ColorMeRad)
      ColorMeRad.send method, *args
    end
  end
end

module Snagglepuss
  extend self

  class Error < StandardError; end

  def exit_gracefully(e)
    return if e.is_a?(SystemExit)

    puts e.backtrace
    puts '=' * 80
    puts Colorize.key('Application trace:', :label)
    puts '-' * 80
    e.backtrace.each do |line|
      puts line if !line.match(/\/\.?asdf\//) && !line.match(/\/\.gems\//)
    end
    puts '=' * 80

    puts '%s: %s' % [
      Colorize.data(e.class),
      Colorize.key(e.message, :error),
    ]

    $stderr.reopen(IO::NULL)
    $stdout.reopen(IO::NULL)
  end

  at_exit do
    exit_gracefully $!
  end
end
