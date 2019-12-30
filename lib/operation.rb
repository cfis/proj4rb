module Proj
  class Operation
    attr_reader :id, :description

    def self.list
      pointer_to_array = FFI::Pointer.new(Api::PJ_OPERATIONS, Api.proj_list_operations)
      result = Array.new
      0.step do |i|
        operation_info = Api::PJ_OPERATIONS.new(pointer_to_array[i])
        break result if operation_info[:id].nil?
        id = operation_info[:id]
        description = operation_info[:descr].read_pointer.read_string.force_encoding('UTF-8')
        result << self.new(id, description)
      end
      result
    end

    def self.get(id)
      self.list.find {|operation| operation.id == id}
    end

    def initialize(id, description)
      @id = id
      @description = description
    end

    def <=>(other)
      self.id <=> other.id
    end

    def ==(other)
      self.id == other.id
    end

    def to_s
      self.id
    end
    
    def inspect
      "#<#{self.class} id=\"#{id}\", major=\"#{major}\", ell=\"#{ell}\", name=\"#{name}\">"
    end
  end
end