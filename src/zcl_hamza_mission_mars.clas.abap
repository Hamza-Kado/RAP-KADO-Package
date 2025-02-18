CLASS zcl_hamza_mission_mars DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    data: itab type table of string.
    INTERFACES if_oo_adt_classrun .
    methods reach_to_mars.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HAMZA_MISSION_MARS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me->reach_to_mars(  ).
    loop at itab into data(wa).
       out->write(
         EXPORTING
           data   = wa

       ).

    ENDLOOP.
  ENDMETHOD.


  method reach_to_mars.
       data lv_text type string.
       data(lo_earth) = new zcl_earth(  ).
       data(lo_planet1) = new zcl_planet1(  ).
       data(lo_mars) = new zcl_mars(  ).

       lv_text = lo_earth->start_engine(  ).
       APPEND lv_text to itab.
       lv_text = lo_earth->leave_orbit(  ).
       APPEND lv_text to itab.

       lv_text = lo_planet1->enter_orbit(  ).
       APPEND lv_text to itab.
       lv_text = lo_planet1->leave_orbit(  ).
       APPEND lv_text to itab.

       lv_text = lo_mars->enter_orbit(  ).
       APPEND lv_text to itab.
       lv_text = lo_mars->explore_mars(  ).
       APPEND lv_text to itab.


    ENDMETHOD.
ENDCLASS.
