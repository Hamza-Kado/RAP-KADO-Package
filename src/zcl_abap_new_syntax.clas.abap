CLASS zcl_abap_new_syntax DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    class-METHODS : s1_loop_with_grouping.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAP_NEW_SYNTAX IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

        zcl_abap_new_syntax=>s1_loop_with_grouping(  ).
*        out->write(
*          EXPORTING
*            data   = lt_bookings
*
*        ).

  ENDMETHOD.


   METHOD s1_loop_with_grouping.
  types: tt_bookings type table of /dmo/booking WITH DEFAULT KEY.
    data : lv_total type p DECIMALS 2.

    select travel_id, booking_id from /dmo/booking into table @data(lt_bookings) up to 20 rows.


    "grouping data by a key
*    loop at lt_bookings into data(ls_bookings) GROUP BY ls_bookings-travel_id.
*
*        write : / 'Travel Request' , ls_bookings-travel_id.
*        WRITE : / 'Bookings :' .
*
*        data(lt_grp_book) = value tt_bookings(  ).
*
*        ""loop at all the child of that group
*        loop at GROUP ls_bookings into data(ls_child_rec).
*            "append lines of itab1 to itab2.
*            lt_grp_book = value #( BASE lt_grp_book ( ls_child_rec ) ).
*
*            WRITE : /(5) ls_child_rec-booking_id, ls_child_rec-carrier_id, ls_child_rec-flight_price.
*            lv_total = lv_total + ls_child_rec-flight_price.
*
*        ENDLOOP.
**
*        WRITE : / 'Total Value of the Bookings :' , lv_total.
*        clear : lv_total.
*    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
