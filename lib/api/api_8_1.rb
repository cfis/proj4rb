module Proj
  module Api
    # Stores a description of a celestial body.
    class ProjCelestialBodyInfo < FFI::Struct
      layout :auth_name, :string,
             :name, :string
    end

    attach_function :proj_context_get_database_structure, [:PJ_CONTEXT, :pointer], :PROJ_STRING_LIST
    attach_function :proj_get_geoid_models_from_database, [:PJ_CONTEXT, :string, :string, :pointer], :PROJ_STRING_LIST
    attach_function :proj_suggests_code_for, [:PJ_CONTEXT, :PJ, :string, :int, :pointer], :pointer
    attach_function :proj_string_destroy, [:pointer], :void

    attach_function :proj_get_celestial_body_list_from_database, [:PJ_CONTEXT, :string, :pointer], :pointer
    attach_function :proj_get_celestial_body_name, [:PJ_CONTEXT, :PJ], :string
    attach_function :proj_celestial_body_list_destroy, [:pointer], :void

    typedef :pointer, :PJ_INSERT_SESSION
    attach_function :proj_insert_object_session_create, [:PJ_CONTEXT], :PJ_INSERT_SESSION
    attach_function :proj_insert_object_session_destroy, [:PJ_CONTEXT, :PJ_INSERT_SESSION], :void
    attach_function :proj_get_insert_statements, [:PJ_CONTEXT, :PJ_INSERT_SESSION, :PJ, :string, :string, :int,
                                                 :pointer , :pointer], :PROJ_STRING_LIST
  end
end