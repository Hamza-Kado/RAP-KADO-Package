*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class zcl_earth DEFINITION.
   PUBLIC SECTION.
     METHODS start_engine RETURNING VALUE(r_value) type string.
     METHODS leave_orbit  RETURNING VALUE(r_value) type string.

ENDCLASS.

class zcl_earth IMPLEMENTATION.
    method start_engine.
       r_value = 'We take off from planet Earth for mission Mars.'.
    endmethod.
    method leave_orbit.
      r_value = 'We leave Earth Orbit'.
    ENDMETHOD.
ENDCLASS.

class zcl_planet1 DEFINITION.
   PUBLIC SECTION.
     METHODS enter_orbit RETURNING VALUE(r_value) type string.
     METHODS leave_orbit  RETURNING VALUE(r_value) type string.

ENDCLASS.

class zcl_planet1 IMPLEMENTATION.
     method enter_orbit.
       r_value = 'We Enter Planet 1 Orbit.'.
    endmethod.
    method leave_orbit.
      r_value = 'We leave Planet 1 Orbit'.
    ENDMETHOD.

ENDCLASS.

class zcl_mars DEFINITION.
   PUBLIC SECTION.
     METHODS explore_mars  returning VALUE(r_value) type string.
     METHODS enter_orbit RETURNING VALUE(r_value) type string.

ENDCLASS.

class zcl_mars IMPLEMENTATION.

   method enter_orbit.
       r_value = 'We Enter Mars Orbit.'.
    endmethod.
    method explore_mars.
      r_value = 'Roger! we found water on Mars'.
    ENDMETHOD.

ENDCLASS.
