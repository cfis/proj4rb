# frozen_string_literal: true

require 'proj'

# Create a dedicated context so we don't affect the default.
context = Proj::Context.new

# Collect log messages into an array.
messages = []

context.set_log_function do |_pointer, level, message|
  messages << "[level=#{level}] #{message}"
end

# Trigger a log message by setting an invalid database path.
begin
  context.database.path = '/nonexistent'
rescue Proj::Error
  # Expected - we just want to see the log output.
end

messages.each { |msg| puts msg }

raise 'no log messages captured' if messages.empty?

puts 'ok'
