#include "ruby.h"
#include "projects.h"
#include "proj_api.h"
 
static VALUE mProjrb;
static VALUE cUnit;
static VALUE cEllipsoid;
static VALUE cDatum;
static VALUE cPrimeMeridian;
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

/**
   :nodoc: Creates a new UV object as a copy of an old one (for dup and clone methods).
*/
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

/** Creates a new projection object. Takes an array of strings corresponding to a list of usual <tt>proj.exe</tt> initialization parameters.
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
/**Return list of all units we know about.
 */
static VALUE unit_list(VALUE self){
  struct PJ_UNITS *unit;
  VALUE list = rb_ary_new();
  for (unit = pj_get_units_ref(); unit->id; unit++){
    rb_ary_push(list, Data_Wrap_Struct(cUnit, 0, 0, unit));
  }
  return list;
}
/**Get ID of the unit.
 */
static VALUE unit_get_id(VALUE self){
  struct PJ_UNITS *unit;
  Data_Get_Struct(self,struct PJ_UNITS,unit);
  return rb_str_new2(unit->id);
}
/**Get conversion factor of this unit to a meter. Note that this is a string, it can either contain a floating point number or it can be in the form numerator/denominator.
 */
static VALUE unit_get_to_meter(VALUE self){
  struct PJ_UNITS *unit;
  Data_Get_Struct(self,struct PJ_UNITS,unit);
  return rb_str_new2(unit->to_meter);
}
/**Get name (description) of the unit.
 */
static VALUE unit_get_name(VALUE self){
  struct PJ_UNITS *unit;
  Data_Get_Struct(self,struct PJ_UNITS,unit);
  return rb_str_new2(unit->name);
}

/**Return list of all reference ellipsoids we know about.
 */
static VALUE ellipsoid_list(VALUE self){
  struct PJ_ELLPS *el;
  VALUE list = rb_ary_new();
  for (el = pj_get_ellps_ref(); el->id; el++){
    rb_ary_push(list, Data_Wrap_Struct(cEllipsoid, 0, 0, el));
  }
  return list;
}
/**Get ID of the reference ellipsoid.
 */
static VALUE ellipsoid_get_id(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->id);
}
/**Get equatorial radius (semi-major axis, a value) of the reference ellipsoid.
 */
static VALUE ellipsoid_get_major(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->major);
}
/**Get elliptical parameter of the reference ellipsoid. This is either the polar radius (semi-minor axis, b value) or the inverse flattening (1/f, rf).
 */
static VALUE ellipsoid_get_ell(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->ell);
}
/**Get name of the reference ellipsoid.
 */
static VALUE ellipsoid_get_name(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->name);
}

/**Return list of all datums we know about.
 */
static VALUE datum_list(VALUE self){
  struct PJ_DATUMS *datum;
  VALUE list = rb_ary_new();
  for (datum = pj_get_datums_ref(); datum->id; datum++){
    rb_ary_push(list, Data_Wrap_Struct(cDatum, 0, 0, datum));
  }
  return list;
}
/**Get ID of the datum.
 */
static VALUE datum_get_id(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->id);
}
/**Get ID of the ellipse used by the datum.
 */
static VALUE datum_get_ellipse_id(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->ellipse_id);
}
/**Get definition of the datum.
 */
static VALUE datum_get_defn(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->defn);
}
/**Get comments about the datum.
 */
static VALUE datum_get_comments(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->comments);
}

/**Return list of all prime meridians we know about.
 */
static VALUE prime_meridian_list(VALUE self){
  struct PJ_PRIME_MERIDIANS *prime_meridian;
  VALUE list = rb_ary_new();
  for (prime_meridian = pj_get_prime_meridians_ref(); prime_meridian->id; prime_meridian++){
    rb_ary_push(list, Data_Wrap_Struct(cPrimeMeridian, 0, 0, prime_meridian));
  }
  return list;
}
/**Get ID of this prime_meridian.
 */
static VALUE prime_meridian_get_id(VALUE self){
  struct PJ_PRIME_MERIDIANS *prime_meridian;
  Data_Get_Struct(self,struct PJ_PRIME_MERIDIANS,prime_meridian);
  return rb_str_new2(prime_meridian->id);
}
/**Get definition of this prime_meridian.
 */
static VALUE prime_meridian_get_defn(VALUE self){
  struct PJ_PRIME_MERIDIANS *prime_meridian;
  Data_Get_Struct(self,struct PJ_PRIME_MERIDIANS,prime_meridian);
  return rb_str_new2(prime_meridian->defn);
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
     Version of C libproj
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
    /* The Unit class holds information about the units (m, km, mi(les), ...) known to Proj.4. */
    cUnit = rb_define_class_under(mProjrb,"Unit",rb_cObject);
    rb_define_singleton_method(cUnit,"list",unit_list,0);
    rb_define_method(cUnit,"id",unit_get_id,0);
    rb_define_method(cUnit,"to_meter",unit_get_to_meter,0);
    rb_define_method(cUnit,"name",unit_get_name,0);

    /* The Ellipsoid class holds information about ellipsoids (WGS84, Bessel, ...) known to Proj.4. */
    cEllipsoid = rb_define_class_under(mProjrb,"Ellipsoid",rb_cObject);
    rb_define_singleton_method(cEllipsoid,"list",ellipsoid_list,0);
    rb_define_method(cEllipsoid,"id",ellipsoid_get_id,0);
    rb_define_method(cEllipsoid,"major",ellipsoid_get_major,0);
    rb_define_method(cEllipsoid,"ell",ellipsoid_get_ell,0);
    rb_define_method(cEllipsoid,"name",ellipsoid_get_name,0);

    /* The Datum class holds information about datums (WGS84, potsdam, ...) known to Proj.4. */
    cDatum = rb_define_class_under(mProjrb,"Datum",rb_cObject);
    rb_define_singleton_method(cDatum,"list",datum_list,0);
    rb_define_method(cDatum,"id",datum_get_id,0);
    rb_define_method(cDatum,"ellipse_id",datum_get_ellipse_id,0);
    rb_define_method(cDatum,"defn",datum_get_defn,0);
    rb_define_method(cDatum,"comments",datum_get_comments,0);

    /* The PrimeMeridian class holds information about prime meridians (greenwich, lisbon, ...) known to Proj.4. */
    cPrimeMeridian = rb_define_class_under(mProjrb,"PrimeMeridian",rb_cObject);
    rb_define_singleton_method(cPrimeMeridian,"list",prime_meridian_list,0);
    rb_define_method(cPrimeMeridian,"id",prime_meridian_get_id,0);
    rb_define_method(cPrimeMeridian,"defn",prime_meridian_get_defn,0);
  #endif

}

