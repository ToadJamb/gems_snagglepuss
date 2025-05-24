# frozen_string_literal: true

module Snagglepuss
  module ShowException
    extend self

    def execute(e)
      exit_stage :right

      show_backtrace_for e

      puts '%s: %s' % [
        Colorize.data(e.class),
        Colorize.key(e.message, :error),
      ]

      exit_stage :left
    end

    private

    def show_backtrace_for(e)
      app_trace = []
      e.backtrace.each do |line|
        formatted = LineFormatter.execute(line)
        puts formatted
        next if EXCLUSIONS.any?{ |e| line.match(e) }

        app_trace << formatted
      end

      puts '%s %s %s' % [
        Colorize.key('<== ', :partition),
        Colorize.key('Application trace', :label),
        Colorize.key('=' * 57 + '>', :partition),
      ]

      puts app_trace

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
  end
end
