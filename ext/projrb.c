#include <ruby.h>
#include <projects.h>
#include <proj_api.h>
 
static VALUE mProjrb;

static VALUE cDef;
static VALUE cDatum;
static VALUE cEllipsoid;
static VALUE cPrimeMeridian;
static VALUE cProjectionType;
static VALUE cUnit;

static VALUE cError;
static VALUE cProjection;

static ID idGetX;
static ID idSetX;
static ID idGetY;
static ID idSetY;
static ID idGetZ;
static ID idSetZ;
static ID idParseInitParameters;
static ID idRaiseError;

typedef struct {projPJ pj;} _wrap_pj;


static void raise_error(int pj_errno_ref) {
  VALUE error_id = INT2NUM(pj_errno_ref);
  rb_funcall(cError, idRaiseError, 1, error_id);
}
 
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


/** Returns the current error message.

   call-seq: Error.message(errno)
   
 */
static VALUE proj_error_message(VALUE self, VALUE rerrno) {
  int error_id = NUM2INT(rerrno);
  char *msg = pj_strerrno(error_id);
  if (msg)
	return rb_str_new2(msg);
  else
    return rb_str_new2("unknown error");
}


/**Creates a new projection object. See the intro for details.

   call-seq: new(String) -> Proj4::Projection
             new(Array) -> Proj4::Projection
             new(Hash) -> Proj4::Projection

 */
static VALUE proj_initialize(VALUE self, VALUE params){
  _wrap_pj* wpj;
  VALUE proj_params = rb_funcall(cProjection, idParseInitParameters, 1, params);
  int size = RARRAY_LEN(proj_params);
  char** c_params = (char **) malloc(size*sizeof(char *));
  int i;

  for (i=0; i < size; i++)
  {
    VALUE item = rb_ary_entry(proj_params, i);
    c_params[i]= StringValuePtr(item); 
  }

  Data_Get_Struct(self,_wrap_pj,wpj);
  wpj->pj = pj_init(size,c_params);
  free(c_params);
  if(wpj->pj == 0) {
    int pj_errno_ref = *pj_get_errno_ref();
    if (pj_errno_ref > 0) {
        rb_raise(rb_eSystemCallError, "Unknown system call error");
    } else {
        raise_error(pj_errno_ref);
    }
  }
  return self;
}

/**Has this projection an inverse?

   call-seq: hasInverse? -> true or false

 */
static VALUE proj_has_inverse(VALUE self){
  _wrap_pj* wpj;
  Data_Get_Struct(self,_wrap_pj,wpj);
  return wpj->pj->inv ? Qtrue : Qfalse;
}

/**Is this projection a latlong projection?

   call-seq: isLatLong? -> true or false

 */
static VALUE proj_is_latlong(VALUE self){
  _wrap_pj* wpj;
  Data_Get_Struct(self,_wrap_pj,wpj);
  return pj_is_latlong(wpj->pj) ? Qtrue : Qfalse;
}

/**Is this projection a geocentric projection?

   call-seq: isGeocentric? -> true or false

 */
static VALUE proj_is_geocent(VALUE self){
  _wrap_pj* wpj;
  Data_Get_Struct(self,_wrap_pj,wpj);
  return pj_is_geocent(wpj->pj) ? Qtrue : Qfalse;
}

/**Get the expanded definition of this projection as a string.

   call-seq: getDef -> String

 */
static VALUE proj_get_def(VALUE self){
  _wrap_pj* wpj;
  Data_Get_Struct(self,_wrap_pj,wpj);
  return rb_str_new2(pj_get_def(wpj->pj, 0));
}

/**Transforms a point in WGS84 LonLat in radians to projected coordinates.
   This version of the method changes the point in-place.

   call-seq: forward!(point) -> point

 */
static VALUE proj_forward(VALUE self,VALUE point){
  _wrap_pj* wpj;
  int pj_errno_ref;
  projLP pj_point;
  projXY pj_result;
  Data_Get_Struct(self,_wrap_pj,wpj);

  pj_point.u = NUM2DBL( rb_funcall(point, idGetX, 0) );
  pj_point.v = NUM2DBL( rb_funcall(point, idGetY, 0) );
  pj_result = pj_fwd(pj_point, wpj->pj);

  pj_errno_ref = *pj_get_errno_ref();
  if (pj_errno_ref == 0) {
    rb_funcall(point, idSetX, 1, rb_float_new(pj_result.u) );
    rb_funcall(point, idSetY, 1, rb_float_new(pj_result.v) );
    return point;
  } else if (pj_errno_ref > 0) {
    rb_raise(rb_eSystemCallError, "Unknown system call error");
  } else {
    raise_error(pj_errno_ref);
  }
  return self; /* Makes gcc happy */
}

/**Transforms a point in the coordinate system defined at initialization of the Projection object to WGS84 LonLat in radians.
   This version of the method changes the point in-place.

   call-seq: inverse!(point) -> point

 */
static VALUE proj_inverse(VALUE self,VALUE point){
  _wrap_pj* wpj;
  int pj_errno_ref;
  projXY pj_point;
  projLP pj_result;

  Data_Get_Struct(self,_wrap_pj,wpj);

  pj_point.u = NUM2DBL( rb_funcall(point, idGetX, 0) );
  pj_point.v = NUM2DBL( rb_funcall(point, idGetY, 0) );
  pj_result = pj_inv(pj_point, wpj->pj);

  pj_errno_ref = *pj_get_errno_ref();
  if (pj_errno_ref == 0) {
    rb_funcall(point, idSetX, 1, rb_float_new(pj_result.u) );
    rb_funcall(point, idSetY, 1, rb_float_new(pj_result.v) );
    return point;
  } else if (pj_errno_ref > 0) {
    rb_raise(rb_eSystemCallError, "Unknown system call error");
  } else {
    raise_error(pj_errno_ref);
  }
  return self; /* Makes gcc happy */
}

/**Transforms a point from one projection to another. The second parameter is
   either a Proj4::Point object or you can use any object which
   responds to the x, y, z read and write accessor methods. (In fact you
   don't even need the z accessor methods, 0 is assumed if they don't exist).
   This is the destructive variant of the method, i.e. it will overwrite your
   existing point coordinates but otherwise leave the point object alone.

   call-seq: transform!(destinationProjection, point) -> point

 */
static VALUE proj_transform(VALUE self, VALUE dst, VALUE point){
  _wrap_pj* wpjsrc;
  _wrap_pj* wpjdst;
  double array_x[1];
  double array_y[1];
  double array_z[1];
  int result;

  Data_Get_Struct(self,_wrap_pj,wpjsrc);
  Data_Get_Struct(dst,_wrap_pj,wpjdst);

  array_x[0] = NUM2DBL( rb_funcall(point, idGetX, 0) );
  array_y[0] = NUM2DBL( rb_funcall(point, idGetY, 0) );

  /* if point objects has a method 'z' we get the z coordinate, otherwise we just assume 0 */
  if ( rb_respond_to(point, idGetZ) ) {
    array_z[0] = NUM2DBL( rb_funcall(point, idGetZ, 0) );
  } else {
    array_z[0] = 0.0;
  }

  result = pj_transform(wpjsrc->pj, wpjdst->pj, 1, 1, array_x, array_y, array_z);
  if (! result) {
    rb_funcall(point, idSetX, 1, rb_float_new(array_x[0]) );
    rb_funcall(point, idSetY, 1, rb_float_new(array_y[0]) );
    /* if point objects has a method 'z=' we set the z coordinate, otherwise we ignore it  */
    if ( rb_respond_to(point, idSetZ) ) {
        rb_funcall(point, idSetZ, 1, rb_float_new(array_z[0]) );
    }
    return point;
  } else if (result > 0) {
    rb_raise(rb_eSystemCallError, "Unknown system call error");
  } else {
    raise_error(result);
  }
  return self; /* Makes gcc happy */
}

#if PJ_VERSION >= 449
/**Return list of all datums we know about.

   call-seq: list -> Array of Proj4::Datum

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

   call-seq: id -> String

 */
static VALUE datum_get_id(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->id);
}
/**Get ID of the ellipse used by the datum.

   call-seq: ellipse_id -> String

 */
static VALUE datum_get_ellipse_id(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->ellipse_id);
}
/**Get definition of the datum.

   call-seq: defn -> String

 */
static VALUE datum_get_defn(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->defn);
}
/**Get comments about the datum.

   call-seq: comments -> String

 */
static VALUE datum_get_comments(VALUE self){
  struct PJ_DATUMS *datum;
  Data_Get_Struct(self,struct PJ_DATUMS,datum);
  return rb_str_new2(datum->comments);
}

/**Return list of all reference ellipsoids we know about.

   call-seq: list -> Array of Proj4::Ellipsoid

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

   call-seq: id -> String

 */
static VALUE ellipsoid_get_id(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->id);
}
/**Get equatorial radius (semi-major axis, a value) of the reference ellipsoid.

   call-seq: major -> String

 */
static VALUE ellipsoid_get_major(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->major);
}
/**Get elliptical parameter of the reference ellipsoid. This is either the polar radius (semi-minor axis, b value) or the inverse flattening (1/f, rf).

   call-seq: ell -> String

 */
static VALUE ellipsoid_get_ell(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->ell);
}
/**Get name of the reference ellipsoid.

   call-seq: name -> String

 */
static VALUE ellipsoid_get_name(VALUE self){
  struct PJ_ELLPS *el;
  Data_Get_Struct(self,struct PJ_ELLPS,el);
  return rb_str_new2(el->name);
}

/**Return list of all prime meridians we know about.

   call-seq: list -> Array of Proj4::PrimeMeridian

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

   call-seq: id -> String

 */
static VALUE prime_meridian_get_id(VALUE self){
  struct PJ_PRIME_MERIDIANS *prime_meridian;
  Data_Get_Struct(self,struct PJ_PRIME_MERIDIANS,prime_meridian);
  return rb_str_new2(prime_meridian->id);
}
/**Get definition of this prime_meridian.

   call-seq: defn -> String

 */
static VALUE prime_meridian_get_defn(VALUE self){
  struct PJ_PRIME_MERIDIANS *prime_meridian;
  Data_Get_Struct(self,struct PJ_PRIME_MERIDIANS,prime_meridian);
  return rb_str_new2(prime_meridian->defn);
}

/**Return list of all projection types we know about.

   call-seq: list -> Array of Proj4::ProjectionType

 */
static VALUE projection_type_list(VALUE self){
  struct PJ_LIST *pt;
  VALUE list = rb_ary_new();
  for (pt = pj_get_list_ref(); pt->id; pt++){
    rb_ary_push(list, Data_Wrap_Struct(cProjectionType, 0, 0, pt));
  }
  return list;
}
/**Get ID of this projection type.

   call-seq: id -> String

 */
static VALUE projection_type_get_id(VALUE self){
  struct PJ_LIST *pt;
  Data_Get_Struct(self,struct PJ_LIST,pt);
  return rb_str_new2(pt->id);
}
/**Get description of this projection type as a multiline string.

   call-seq: descr -> String

 */
static VALUE projection_type_get_descr(VALUE self){
  struct PJ_LIST *pt;
  Data_Get_Struct(self,struct PJ_LIST,pt);
  return rb_str_new2(*(pt->descr));
}

/**Return list of all units we know about.

   call-seq: list -> Array of Proj4::Unit

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

   call-seq: id -> String

 */
static VALUE unit_get_id(VALUE self){
  struct PJ_UNITS *unit;
  Data_Get_Struct(self,struct PJ_UNITS,unit);
  return rb_str_new2(unit->id);
}
/**Get conversion factor of this unit to a meter. Note that this is a string, it can either contain a floating point number or it can be in the form numerator/denominator.

   call-seq: to_meter -> String

 */
static VALUE unit_get_to_meter(VALUE self){
  struct PJ_UNITS *unit;
  Data_Get_Struct(self,struct PJ_UNITS,unit);
  return rb_str_new2(unit->to_meter);
}
/**Get name (description) of the unit.

   call-seq: name -> String

 */
static VALUE unit_get_name(VALUE self){
  struct PJ_UNITS *unit;
  Data_Get_Struct(self,struct PJ_UNITS,unit);
  return rb_str_new2(unit->name);
}

#endif

#if defined(_WIN32)
__declspec(dllexport) 
#endif
void Init_proj4_ruby(void) {

  idGetX = rb_intern("x");
  idSetX = rb_intern("x=");
  idGetY = rb_intern("y");
  idSetY = rb_intern("y=");
  idGetZ = rb_intern("z");
  idSetZ = rb_intern("z=");
  idParseInitParameters = rb_intern("_parse_init_parameters");
  idRaiseError = rb_intern("raise_error");

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

  cError = rb_define_class_under(mProjrb,"Error",rb_path2class("StandardError"));
  rb_define_singleton_method(cError,"message",proj_error_message,1);

  cProjection = rb_define_class_under(mProjrb,"Projection",rb_cObject);
  rb_define_alloc_func(cProjection,proj_alloc);
  rb_define_method(cProjection,"initialize",proj_initialize,1);
  rb_define_method(cProjection,"hasInverse?",proj_has_inverse,0);
  rb_define_method(cProjection,"isLatLong?",proj_is_latlong,0);
  rb_define_method(cProjection,"isGeocent?",proj_is_geocent,0);
  rb_define_alias(cProjection,"isGeocentric?","isGeocent?");
  rb_define_method(cProjection,"getDef",proj_get_def,0);
  rb_define_method(cProjection,"forward!",proj_forward,1);
  rb_define_method(cProjection,"inverse!",proj_inverse,1);
  rb_define_method(cProjection,"transform!",proj_transform,2);

  #if PJ_VERSION >= 449
    cDef = rb_define_class_under(mProjrb,"Def",rb_cObject);

    /* The Datum class holds information about datums ('WGS84', 'potsdam', ...) known to Proj.4. */
    cDatum = rb_define_class_under(mProjrb,"Datum",cDef);
    rb_define_singleton_method(cDatum,"list",datum_list,0);
    rb_define_method(cDatum,"id",datum_get_id,0);
    rb_define_method(cDatum,"ellipse_id",datum_get_ellipse_id,0);
    rb_define_method(cDatum,"defn",datum_get_defn,0);
    rb_define_method(cDatum,"comments",datum_get_comments,0);

    /* The Ellipsoid class holds information about ellipsoids ('WGS84', 'bessel', ...) known to Proj.4. */
    cEllipsoid = rb_define_class_under(mProjrb,"Ellipsoid",cDef);
    rb_define_singleton_method(cEllipsoid,"list",ellipsoid_list,0);
    rb_define_method(cEllipsoid,"id",ellipsoid_get_id,0);
    rb_define_method(cEllipsoid,"major",ellipsoid_get_major,0);
    rb_define_method(cEllipsoid,"ell",ellipsoid_get_ell,0);
    rb_define_method(cEllipsoid,"name",ellipsoid_get_name,0);

    /* The PrimeMeridian class holds information about prime meridians ('greenwich', 'lisbon', ...) known to Proj.4. */
    cPrimeMeridian = rb_define_class_under(mProjrb,"PrimeMeridian",cDef);
    rb_define_singleton_method(cPrimeMeridian,"list",prime_meridian_list,0);
    rb_define_method(cPrimeMeridian,"id",prime_meridian_get_id,0);
    rb_define_method(cPrimeMeridian,"defn",prime_meridian_get_defn,0);

    /* The ProjectionType class holds information about projections types ('merc', 'aea', ...) known to Proj.4. */
    cProjectionType = rb_define_class_under(mProjrb,"ProjectionType",cDef);
    rb_define_singleton_method(cProjectionType,"list",projection_type_list,0);
    rb_define_method(cProjectionType,"id",projection_type_get_id,0);
    rb_define_method(cProjectionType,"descr",projection_type_get_descr,0);

    /* The Unit class holds information about the units ('m', 'km', 'mi', ...) known to Proj.4. */
    cUnit = rb_define_class_under(mProjrb,"Unit",cDef);
    rb_define_singleton_method(cUnit,"list",unit_list,0);
    rb_define_method(cUnit,"id",unit_get_id,0);
    rb_define_method(cUnit,"to_meter",unit_get_to_meter,0);
    rb_define_method(cUnit,"name",unit_get_name,0);
  #endif
}
