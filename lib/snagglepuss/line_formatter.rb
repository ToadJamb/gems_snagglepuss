# frozen_string_literal: true

module Snagglepuss
  module LineFormatter
    extend self

    def execute(line)
      return line unless Colorize.enabled?
      return Colorize.key(line, :stacktrace) unless full_match?(line)

      values = line.split(':')

      path = values[0]
      number = values[1]
      description = values[2..-1].join(':')

      location = description.gsub(/in /, '')

      '%s:%s in %s' % [
        Colorize.key(path, :path),
        Colorize.data(number.to_i),
        Colorize.key(location, :location),
      ]
    end

    private

    def full_match?(line)
      line.match(/[\/\w]+:\d+:in `.*'$/)
    end
  end
end
