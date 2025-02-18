CLASS zcl_ats_ha_region_add DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    TYPES: BEGIN OF TY_REGION,
      client TYPE  mandt,
      region TYPE zats_ha_dte_region,
      regionname TYPE ZATS_HA_DTE_REGION,
      END OF TY_REGION.

    TYPES: tt_region TYPE STANDARD TABLE OF ty_region.
    data: it_region TYPE STANDARD TABLE OF ty_region.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ATS_HA_REGION_ADD IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA : it_region TYPE STANDARD TABLE OF zats_ha_region,
           lt_course  TYPE STANDARD TABLE OF z07_course.
    it_region = VALUE #( ( client = '100' region = 'AF' regionname = 'Africa' )
                         ( client = '100' region = 'AN' regionname = 'Antarctica' )
                         ( client = '100' region = 'APJ' regionname = 'Asia Pacific Jap' )
                         ( client = '100' region = 'EMEA' regionname = 'Europe Middle Ea' )
                         ( client = '100' region = 'NA' regionname = 'North America' )
                         ( client = '100' region = 'OC' regionname = 'Oceania' )
                         ( client = '100' region = 'SA' regionname = 'South America' ) ).

    INSERT zats_ha_region FROM TABLE @it_region.
    out->write( |{ sy-dbcnt } entries successfully inserted in Region Master.| ).




  ENDMETHOD.
ENDCLASS.
