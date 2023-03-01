# encoding: UTF-8
require 'forwardable'

module Proj
  class Strings
    include Enumerable
    extend Forwardable

    attr_reader :strings

    def initialize(pointer)
      @strings = Array.new
      read_strings(pointer)
      Api.proj_string_list_destroy(pointer)
    end

    private

    def read_strings(pointer)
      unless pointer.null?
        loop do
          string_ptr = pointer.read_pointer
          break if string_ptr.null?
          @strings << string_ptr.read_string_to_null
          pointer += FFI::Pointer::SIZE
        end
      end
    end

    def_delegators :@strings, :[], :count, :each, :empty?, :join, :size, :length, :to_s
  end
end
