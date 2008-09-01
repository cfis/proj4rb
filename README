=Proj4rb

This is a Ruby binding for the Proj.4 Carthographic Projection library
(http://trac.osgeo.org/proj/), that supports conversions between a large
number of geographic coordinate systems and datums.

Most functions of the C library are exposed to Ruby. In cases where
there is a direct equivalent between C and Ruby, identifiers (such as names of
functions and constants) are the same. But the usage has been changed to
take advantage of Ruby's object-oriented features.

== Operations
To load the library:
  require 'proj4'

The classes are in the Proj4 module so you may wish to include it:
  include Proj4

Next, you need to create a projection:
    proj = Projection.new( :proj => "utm", :zone => "21", :units => "m" )

This defines a UTM21 North projection in WGS84. Note that the <tt>proj</tt> /
<tt>proj.exe</tt> initialization arguments equivalent to the one above would
be:
    +proj=utm +zone=21 +units=m

Note there are several alternative ways of specifying the arguments, see
the documentation for Proj4::Projection.new for details.

Once you've created the projection, you can tranform coordinates using either
the +forward+ or +inverse+ methods.  +forward+ transforms the point in WGS84
lon/lat (in radians) to the coordinate system defined during the creation 
of the Projection object. +inverse+ does the opposite. For example:

    projected_point = proj.forward(lonlat_point)
    lonlat_point = proj.inverse(projected_point)

There is also a +transform+ function which can transform between any two
projections including datum conversions:

    point_in_projB = projA.transform(projB, point_in_projA)

The +forward+, +inverse+, and +transform+ methods all have an in-place
equivalent: <tt>forward!</tt>, <tt>inverse!</tt>, and <tt>transform!</tt>
which projects the given point in place. There are also +forwardDeg+
and +inverseDeg+ methods which work with longitudes and latitudes in
degrees rather than radians.

For the points you can use an object of the Proj4::Point class. It has 
properties: +x+, +y+, and +z+, which can be set and retrieved. Aliases
+lon+ and +lat+ for +x+ and +y+, respectively, are also available.
(There used to be a UV class, but this has been removed in version 0.3.0.)

Instead of using the Proj4::Point object, you may use another class as long
as it responds to the methods +x+ and +y+ (and +z+ for 3D datum transformations
with the +transform+ method).

The methods +forward_all+, +inverse_all+, and +transform_all+ (and their
in-place versions <tt>forward_all!</tt>, <tt>inverse_all!</tt>, and
<tt>transform_all!</tt> work just like their simple counterparts, but
instead of transforming a single point they transform a collection of points 
in a single call.  They take an array as an argument or any object that responds
to the +each+ method (for the in-place versions) or +each+, +clear+, and
<tt><<</tt> methods (for the normal version).

The library also defines two constants to make it easy to convert between
degrees and radians:
+DEG_TO_RAD+ and +RAD_TO_DEG+
 
==Error handling
Projection initialization (Proj4::Projection.new) and transformation functions
(Proj4::Projection#forward/inverse/transform) all throw exceptions when
they encounter an error.  This is done by mapping proj4's C error codes to 
Ruby specific exception classes.  See Proj4::Error for more information or
use the <tt>list-errors.rb</tt> program from the examples for a list.

==Definition lists
Proj.4 supports many different datums, ellipsoids, prime meridians,
projection types and length units. Use the Proj4::Datum, Proj4::Ellipsoid,
Proj4::PrimeMeridian, Proj4::ProjectionType, and Proj4::Unit classes
to access this information and get detailed information about each definition.
See the <i>list-*</i> files in the <i>example</i> directory for code
examples.

Note that these lists rquire version 449 or later of the Proj.4 C library.

==Installation
To install the gem simply type:
    gem install proj4rb

==Compiling
===Linux
To compile the proj4rb Ruby bindings from source you'll need the
Proj.4 C library installed. Then simply call:
    rake build

If there is a problem, you can perform this step manually:
Enter the <i>ext</i> directory and create
a Makefile:
    cd ext
    ruby extconf.rb
If there are any problems consult the <i>mkmf.log</i> log file.
Then compile with
    make
The result is the file <i>proj4_ruby.so</i>.

If you want to run the tests call
    rake test

If you want to, you can now create a gem with
    rake gem

This will create a file <tt>proj4rb-<i>version</i>-i486-linux.gem</tt>
or similar in the <i>pkg</i> directory.

===Mac OS X
To compile the proj4rb Ruby bindings from source you'll need the
Proj.4 C library installed. Enter the <i>ext</i> directory and create
a Makefile:
    cd ext
    ruby extconf.rb
If there are any problems consult the <i>mkmf.log</i> log file.
Then compile with
    make
The result is the file <i>projrb.bundle</i> which you need to copy into
the <i>lib</i> directory:
    cp projrb.bundle ../lib/

If you want to, you can now create a gem with
    rake gem

This will create a file <tt>proj4rb-<i>version</i>-universal-darwin8.0.gem</tt>
or similar in the <i>pkg</i> directory.

===Windows
To build the library on Windows requires a working installation of Visual
Studio or MingW/msys.  You of course also need to have proj4 installed.

If you are using Visual Studio, you'll find a Visual Studio 2008 project 
file in ext/vc.  You'll have to edit the various include and library paths
to fit your specific environment.

If you are using MingW/msys, then:

1.  Open a msys prompt (a DOS prompt may also work)
2.  Change diretories to ext/MingW
3.  Type in rake

The result is a proj4_ruby.so file which can be package into a GEM or 
copied to the ruby/site-lib directory.

==License
Proj4rb is released under the MIT license.

==Support
Any questions, enhancement proposals, bug notifications or corrections can be
sent to mailto:jochen@topf.org.

==Authors
The proj4rb Ruby bindings were started by Guilhem Vellut with most of the code 
written by Jochen Topf.  Charlie Savage ported the code to Windows and added 
the Windows build infrastructure.

