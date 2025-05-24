# frozen_string_literal: true

require_relative 'snagglepuss/version'
require_relative 'snagglepuss/colorize'
require_relative 'snagglepuss/line_formatter'
require_relative 'snagglepuss/show_exception'

module Snagglepuss
  extend self

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

    ShowException.execute e

    $stderr.reopen(IO::NULL)
    $stdout.reopen(IO::NULL)
  end

  at_exit do
    exit_stage_right $!
  end
end
