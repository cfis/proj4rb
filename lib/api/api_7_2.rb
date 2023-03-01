module Proj
  module Api
    attach_function :proj_context_clone, [:PJ_CONTEXT], :PJ_CONTEXT
    attach_function :proj_context_set_ca_bundle_path, [:PJ_CONTEXT, :string], :void

    attach_function :proj_crs_get_datum_ensemble, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_crs_get_datum_forced, [:PJ_CONTEXT, :PJ], :PJ
    attach_function :proj_datum_ensemble_get_member_count, [:PJ_CONTEXT, :PJ], :int
    attach_function :proj_datum_ensemble_get_accuracy, [:PJ_CONTEXT, :PJ], :double
    attach_function :proj_datum_ensemble_get_member, [:PJ_CONTEXT, :PJ, :int], :PJ
    attach_function :proj_dynamic_datum_get_frame_reference_epoch, [:PJ_CONTEXT, :PJ], :double
  end
end