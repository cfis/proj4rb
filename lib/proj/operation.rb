module Proj
  # Represents a PROJ operation (projection or conversion method).
  # Each operation has an identifier and a human-readable description.
  #
  # @example List all operations
  #   operations = Proj::Operation.list
  #   operations.each { |op| puts "#{op.id}: #{op.description}" }
  #
  # @example Find a specific operation
  #   op = Proj::Operation.get("aea")
  #   puts op.description  #=> "Albers Equal Area"
  class Operation
    # @!attribute [r] id
    #   @return [String] The operation identifier (e.g., "aea", "merc")
    # @!attribute [r] description
    #   @return [String] Human-readable description of the operation
    attr_reader :id, :description

    # Returns a list of all available operations.
    #
    # @return [Array<Operation>]
    def self.list
      pointer_to_array = FFI::Pointer.new(Api::PjList, Api.proj_list_operations)
      result = Array.new
      0.step do |i|
        operation_info = Api::PjList.new(pointer_to_array[i])
        break result if operation_info[:id].nil?
        id = operation_info[:id]
        description = operation_info[:descr].read_pointer.read_string.force_encoding('UTF-8')
        result << self.new(id, description)
      end
      result
    end

    # Finds an operation by its identifier.
    #
    # @param id [String] The operation identifier to search for
    #
    # @return [Operation, nil] The matching operation or nil if not found
    def self.get(id)
      self.list.find {|operation| operation.id == id}
    end

    # Creates a new Operation.
    #
    # @param id [String] The operation identifier
    # @param description [String] Human-readable description
    #
    # @return [Operation]
    def initialize(id, description)
      @id = id
      @description = description
    end

    def ==(other)
      self.id == other.id
    end

    def to_s
      self.id
    end

    def inspect
      "#<#{self.class} id=\"#{id}\", description=\"#{description}\">"
    end
  end
end