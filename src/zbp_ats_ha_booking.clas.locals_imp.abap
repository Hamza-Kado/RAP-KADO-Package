CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Supplements FOR NUMBERING
      IMPORTING entities FOR CREATE Booking\_Supplements.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Supplements.

  data max_booking_suppl_id type /dmo/booking_supplement_id.


*  STEP 1: get all the Travel request and their booking data
   read entities of zats_ha_travel in LOCAL MODE "local mode means no authorization (i.e do not check for authorizations)
   ENTITY booking by \_Supplements
   from CORRESPONDING #( entities )
   link data(booking_supplements).
   "loop at unique ids
   loop at entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY  <booking_group>-%tky.
*  STEP 2: get the highest booking supplement number which is already there
      loop at booking_supplements into data(ls_booking) using key entity
        where source-Travelid = <booking_group>-Travelid and
              source-BookingId = <booking_group>-BookingId.
        if max_booking_suppl_id < ls_booking-target-BookingSupplementId.
          max_booking_suppl_id = ls_booking-target-BookingSupplementId.
        ENDIF.
      ENDLOOP.
*  STEP 3: get the assigned booking supplement number for incoming request
    loop at entities into data(ls_entity) using key entity
        where Travelid = <booking_group>-Travelid and
              bookingid = <booking_group>-BookingId.
          loop at ls_entity-%target into data(ls_target).
            if max_booking_suppl_id < ls_target-BookingSupplementId.
               max_booking_suppl_id = ls_target-BookingSupplementId.
            ENDIF.
          ENDLOOP.

      ENDLOOP.
*  STEP 4: loop over all the entities of Travel with same Travel id
     loop at entities ASSIGNING FIELD-SYMBOL(<booking>)
         USING KEY entity WHERE Travelid = <booking_group>-TravelId and
                                bookingid = <booking_group>-BookingId.
*  STEP 5: Assign new booking id to the booking entity inside each travel
        LOOP at <booking>-%target ASSIGNING FIELD-SYMBOL(<bookingSuppl_wo_numbers>).
          append CORRESPONDING #( <bookingSuppl_wo_numbers> ) to mapped-booksuppl
          ASSIGNING FIELD-SYMBOL(<mapped_bookingSuppl>).
          if <mapped_bookingSuppl>-BookingSupplementId is initial.
             max_booking_suppl_id += 1.
             <mapped_bookingSuppl>-BookingSupplementId = max_booking_suppl_id.
          endif.
         ENDLOOP.
    ENDloop.
  ENDLOOP.

*  data: max_id type  /dmo/booking_supplement_id.
*
**  *  STEP 1: get all the Travel request and their booking data
*   read entities of zats_ha_travel in LOCAL MODE "local mode means no authorization (i.e do not check for authorizations)
*   ENTITY booking by \_Supplements
*   from CORRESPONDING #( entities )
*   link data(booSupp).
*   "loop at unique ids
*
*   loop at entities into data(w_entities).
**    if w_entities-%target-
*       loop at booSupp into data(w_booSupp) where source-TravelId = w_entities-TravelId and source-BookingId = w_entities-BookingId.
*        if max_id < w_booSupp-target-BookingSupplementId.
*          max_id = w_booSupp-target-BookingSupplementId.
*        endif.
*       LOOP at w_entities-%target ASSIGNING FIELD-SYMBOL(<fs_supp>).
*        APPEND CORRESPONDING #( <fs_supp> ) to mapped-booksuppl ASSIGNING  FIELD-SYMBOL(<mapped_suppl>).
*        if <mapped_suppl>-BookingSupplementId is initial.
*         max_id += 1.
*         <mapped_suppl>-BookingSupplementId = max_id.
*        endif.
*       ENDLOOP.
*
*       endloop.
*   ENDLOOP.


  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
