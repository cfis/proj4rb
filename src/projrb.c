#include "ruby.h"
#include "proj_api.h"
 
static VALUE mProjrb;
static VALUE cUV;
static VALUE cProjection;

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

static VALUE uv_get_u(VALUE self){
  projUV* uv;
  Data_Get_Struct(self,projUV,uv);
  return rb_float_new(uv->u);
}

static VALUE uv_get_v(VALUE self){
  projUV* uv;
  Data_Get_Struct(self,projUV,uv);
  return rb_float_new(uv->v);
}

static VALUE uv_set_u(VALUE self, VALUE u){
  projUV* uv;
  Data_Get_Struct(self,projUV,uv);
  uv->u = NUM2DBL(u);
  return u;
}

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

//Goes from WGS84 LatLon to projected coordinates
static VALUE proj_forward(VALUE self,VALUE uv){
  _wrap_pj* wpj;
  projUV* c_uv;
  projUV* pResult;
  Data_Get_Struct(self,_wrap_pj,wpj);
  Data_Get_Struct(uv,projUV,c_uv);
  pResult = (projUV*) malloc(sizeof(projUV));
  pResult->u = c_uv->u * DEG_TO_RAD;
  pResult->v = c_uv->v * DEG_TO_RAD;
  //Pass a pResult equal to uv in Rad as entry to the forward procedure
  *pResult = pj_fwd(*pResult,wpj->pj);
  return Data_Wrap_Struct(cUV,0,uv_free,pResult);
}

//Goes from the projected coordinates to WGS84 LatLon
static VALUE proj_inverse(VALUE self,VALUE uv){
  _wrap_pj* wpj;
  projUV* c_uv;
  projUV* pResult;
  Data_Get_Struct(self,_wrap_pj,wpj);
  Data_Get_Struct(uv,projUV,c_uv);
  pResult = (projUV*) malloc(sizeof(projUV));
  *pResult = pj_inv(*c_uv,wpj->pj);
  pResult->u *= RAD_TO_DEG;
  pResult->v *= RAD_TO_DEG;
  return Data_Wrap_Struct(cUV,0,uv_free,pResult);
}

void Init_projrb(void) {
  mProjrb = rb_define_module("Proj4");
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
  rb_define_method(cProjection,"forward",proj_forward,1);
  rb_define_method(cProjection,"inverse",proj_inverse,1);
}

