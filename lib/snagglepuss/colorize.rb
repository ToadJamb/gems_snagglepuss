# frozen_string_literal: true

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

module Snagglepuss
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
end
