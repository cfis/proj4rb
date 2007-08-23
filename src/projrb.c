#include "ruby.h"
#include "projects.h"
#include "proj_api.h"
 
static VALUE mProjrb;
static VALUE cUV;
static VALUE cProjection;
static VALUE cCs2Cs;

static void uv_free(void *p) {
  free((projUV*)p);
}

static VALUE uv_alloc(VALUE klass) {
  projUV *uv;
  VALUE obj;
  uv = (projUV*) malloc(sizeof(projUV));
  obj = Data_Wrap_Struct(klass, 0, uv_free, uv);
  return obj;
}

/**
   Creates a new UV object. Can contain both lat/lon and projected points.
*/
static VALUE uv_initialize(VALUE self, VALUE u, VALUE v){
  projUV* uv;
  Data_Get_Struct(self,projUV,uv);
  uv->u = NUM2DBL(u);
  uv->v = NUM2DBL(v);
  return self;
}

static VALUE uv_init_copy(VALUE copy,VALUE orig){
  projUV* copy_uv;
  projUV* orig_uv;
  if(copy == orig)
    return copy;
  if (TYPE(orig) != T_DATA ||
      RDATA(orig)->dfree != (RUBY_DATA_FUNC)uv_free) {
    rb_raise(rb_eTypeError, "wrong argument type");
  }

  Data_Get_Struct(orig, projUV, orig_uv);
  Data_Get_Struct(copy, projUV, copy_uv);
  MEMCPY(copy_uv, orig_uv, projUV, 1);
  return copy;
}

/**
   Gives the +u+ dimension of the UV object.
*/
static VALUE uv_get_u(VALUE self){
  projUV* uv;
  Data_Get_Struct(self,projUV,uv);
  return rb_float_new(uv->u);
}

/**
   Gives the +v+ dimension of the UV object.
*/
static VALUE uv_get_v(VALUE self){
  projUV* uv;
  Data_Get_Struct(self,projUV,uv);
  return rb_float_new(uv->v);
}

/**
   Sets the +u+ dimension of the UV object.
*/
static VALUE uv_set_u(VALUE self, VALUE u){
  projUV* uv;
  
  Data_Get_Struct(self,projUV,uv);
  uv->u = NUM2DBL(u);
  return u;
}

/**
   Sets the +v+ dimension of the UV object.
*/
static VALUE uv_set_v(VALUE self, VALUE v){
  projUV* uv;
  Data_Get_Struct(self,projUV,uv);
  uv->v = NUM2DBL(v);
  return v;
}

typedef struct {projPJ pj;} _wrap_pj;

static void proj_free(void* p){
  _wrap_pj * wpj = (_wrap_pj*) p;
  if(wpj->pj != 0)
    pj_free(wpj->pj);
  free(p);
}

static VALUE proj_alloc(VALUE klass){
  _wrap_pj* wpj;
  VALUE obj;
  wpj = (_wrap_pj*) malloc(sizeof(_wrap_pj));
  wpj->pj = 0; //at init the projection has not been defined
  obj = Data_Wrap_Struct(klass, 0, proj_free, wpj);
  return obj;
}

/** Creates a new projection. Takes an array of strings corresponding to a list of usual <tt>proj.exe</tt> initialization parameters.
 */
static VALUE proj_initialize(VALUE self, VALUE proj_params){
  _wrap_pj* wpj;
  int size = RARRAY(proj_params)->len; 
  char** c_params = (char **) malloc(size*sizeof(char *));
  VALUE *ptr = RARRAY(proj_params)->ptr; 
  int i;
  for (i=0; i < size; i++, ptr++)
    c_params[i]= STR2CSTR(*ptr); 
  Data_Get_Struct(self,_wrap_pj,wpj);
  wpj->pj = pj_init(size,c_params);
  if(wpj->pj == 0)
    rb_raise(rb_eArgError,"invalid initialization parameters");
  free(c_params);
  return self;
}

/**Is this projection a latlong projection?
 */
static VALUE proj_is_latlong(VALUE self){
  _wrap_pj* wpj;
  Data_Get_Struct(self,_wrap_pj,wpj);
  return pj_is_latlong(wpj->pj) ? Qtrue : Qfalse;
}

/**Is this projection a geocentric projection?
 */
static VALUE proj_is_geocent(VALUE self){
  _wrap_pj* wpj;
  Data_Get_Struct(self,_wrap_pj,wpj);
  return pj_is_geocent(wpj->pj) ? Qtrue : Qfalse;
}

/**Transforms a point in WGS84 LonLat in radians to projected coordinates.
 */
static VALUE proj_forward(VALUE self,VALUE uv){
  _wrap_pj* wpj;
  projUV* c_uv;
  projUV* pResult;
  Data_Get_Struct(self,_wrap_pj,wpj);
  Data_Get_Struct(uv,projUV,c_uv);
  pResult = (projUV*) malloc(sizeof(projUV));
  pResult->u = c_uv->u;
  pResult->v = c_uv->v;
  //Pass a pResult equal to uv in Rad as entry to the forward procedure
  *pResult = pj_fwd(*pResult,wpj->pj);
  return Data_Wrap_Struct(cUV,0,uv_free,pResult);
}

/**Transforms a point in the coordinate system defined at initialization of the Projection object to WGS84 LonLat in radians.
 */
static VALUE proj_inverse(VALUE self,VALUE uv){
  _wrap_pj* wpj;
  projUV* c_uv;
  projUV* pResult;
  Data_Get_Struct(self,_wrap_pj,wpj);
  Data_Get_Struct(uv,projUV,c_uv);
  pResult = (projUV*) malloc(sizeof(projUV));
  *pResult = pj_inv(*c_uv,wpj->pj);
  return Data_Wrap_Struct(cUV,0,uv_free,pResult);
}

#if PJ_VERSION >= 449
/**Return list of all units the proj lib knows about.
 */
static VALUE proj_list_units(VALUE self){
  struct PJ_UNITS *unit;
  VALUE units = rb_ary_new();
  for (unit = pj_get_units_ref(); unit->id; unit++){
    rb_ary_push(units, rb_str_new2(unit->id));
  }
  return units;
}
#endif

void Init_projrb(void) {
  mProjrb = rb_define_module("Proj4");

  /**
     Radians per degree
  */
  rb_define_const(mProjrb,"DEG_TO_RAD", rb_float_new(DEG_TO_RAD));
  /**
     Degrees per radian
  */
  rb_define_const(mProjrb,"RAD_TO_DEG", rb_float_new(RAD_TO_DEG));
  /**
     Version of libproj
  */
  rb_define_const(mProjrb,"LIBVERSION", rb_float_new(PJ_VERSION));

  cUV = rb_define_class_under(mProjrb,"UV",rb_cObject);
  rb_define_alloc_func(cUV,uv_alloc);
  rb_define_method(cUV,"initialize",uv_initialize,2);
  rb_define_method(cUV,"initialize_copy",uv_init_copy,1);
  rb_define_method(cUV,"u",uv_get_u,0);
  rb_define_method(cUV,"v",uv_get_v,0);
  rb_define_method(cUV,"u=",uv_set_u,1);
  rb_define_method(cUV,"v=",uv_set_v,1);
 
  cProjection = rb_define_class_under(mProjrb,"Projection",rb_cObject);
  rb_define_alloc_func(cProjection,proj_alloc);
  rb_define_method(cProjection,"initialize",proj_initialize,1);
  rb_define_method(cProjection,"isLatLong?",proj_is_latlong,0);
  rb_define_method(cProjection,"isGeocent?",proj_is_geocent,0);
  rb_define_alias(cProjection,"isGeocentric?","isGeocent?");
  rb_define_method(cProjection,"forward",proj_forward,1);
  rb_define_method(cProjection,"inverse",proj_inverse,1);

  #if PJ_VERSION >= 449
    rb_define_singleton_method(cProjection,"listUnits",proj_list_units,0);
  #endif
}

