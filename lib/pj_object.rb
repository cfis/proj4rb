# encoding: UTF-8
module Proj
  class PjObject
    attr_reader :context

    def self.finalize(pointer)
      proc do
        Api.proj_destroy(pointer)
      end
    end

    def initialize(pointer, context=nil)
      @pointer = pointer
      @context = context
      ObjectSpace.define_finalizer(self, self.class.finalize(@pointer))
    end

    def to_ptr
      @pointer
    end

    def context
      @context || Context.current
    end

    def proj_type
      Api.proj_get_type(self)
    end

    def info
      Api.proj_pj_info(self)
    end

    def id
      self.info[:id]
    end

    def name
      Api.proj_get_name(self).force_encoding('UTF-8')
    end

    def auth_name(index=0)
      Api.proj_get_id_auth_name(self, index).force_encoding('UTF-8')
    end

    def auth_code(index=0)
      Api.proj_get_id_code(self, index)
    end

    def auth(index=0)
      "#{self.auth_name(index)}:#{self.auth_code(index)}"
    end

    def description
      self.info[:description] ? self.info[:description].force_encoding('UTF-8') : nil
    end

    def definition
      self.info[:definition] ? self.info[:definition].force_encoding('UTF-8') : nil
    end

    def has_inverse?
      self.info[:has_inverse] == 1 ? true : false
    end

    def accuracy
      self.info[:accuracy]
    end

    def to_proj_string(string_type=:PJ_PROJ_4)
      Api.proj_as_proj_string(self.context, self, string_type, nil).force_encoding('UTF-8')
    end

    def to_json
      Api.proj_as_projjson(self.context, self, nil).force_encoding('UTF-8')
    end

    def to_wkt(wkt_type=:PJ_WKT2_2018)
      Api.proj_as_wkt(self.context, self, wkt_type, nil).force_encoding('UTF-8')
    end
  end
end
