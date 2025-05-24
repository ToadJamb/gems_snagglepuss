# frozen_string_literal: true

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
