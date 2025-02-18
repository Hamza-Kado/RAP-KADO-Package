CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~copytravel.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR travel RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE travel.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE travel\_booking.



ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    data: entity type STRUCTURE FOR CREATE zats_ha_travel,
          travel_id_max type /dmo/travel_id.

    "STEP 1: Ensure that Travel Id is not set for the record which is comming
    loop at entities into entity WHERE Travelid is not initial.
      APPEND CORRESPONDING #(  entity ) to mapped-travel.
    ENDLOOP.

    data(entities_wo_travelid) = entities.
    delete entities_wo_travelid where Travelid is not INITIAL.
   "STEP 2: Get the sequence numbers from SNRO

   try.

     cl_numberrange_runtime=>number_get(
       EXPORTING
         nr_range_nr       = '01'
         object            = '/DMO/TRAVL'
         quantity          = conv #(  lines( entities_wo_travelid ) )
       IMPORTING
         number            = DATA(number_range_key)
         returncode        = data(number_range_return_code)
         returned_quantity = data(number_range_returned_quantity)
     ).
*     CATCH cx_nr_object_not_found.
*     CATCH cx_number_ranges.

     catch cx_number_ranges into data(lx_number_ranges).
     "STEP 3: if there is an exception, we will throw an error
     loop at entities_wo_travelid into entity.
       append value #( %CID = entity-%cid  %key = entity-%key %msg = lx_number_ranges )
       to reported-travel.
        append value #( %CID = entity-%cid  %key = entity-%key ) to failed-travel.
     ENDLOOP.
       exit.

   endtry.


   case number_range_return_code.
     when '1'.
         "STEP 4: Handle special cases where the number range exceed critical %
       loop at entities_wo_travelid into entity.
        append value #( %CID = entity-%cid  %key = entity-%key
         %msg = new /dmo/cm_flight_messages(
                                            textid = /dmo/cm_flight_messages=>number_range_depleted
                                            severity = if_abap_behv_message=>severity-warning
                                            ) ) to reported-travel.
     ENDLOOP.

     when '2' OR '3'.
     "STEP 5: The number range return last number, or number exhausted
      append value #( %CID = entity-%cid  %key = entity-%key
         %msg = new /dmo/cm_flight_messages(
                                            textid = /dmo/cm_flight_messages=>not_sufficient_numbers
                                            severity = if_abap_behv_message=>severity-warning

                                         ) ) to reported-travel.
      append value #( %CID = entity-%cid
                      %key = entity-%key
                      %fail-cause = if_abap_behv=>cause-conflict
                      ) to failed-travel.
   ENDCASE.

   "STEP 6: Final check for all numbers
     ASSERT number_range_returned_quantity = lines( entities_wo_travelid ).

     "STEP 7: Loop over the incoming travel data and assign the numbers from number range
     " and returned mapped data which will then go to RAP framework
     travel_id_max = number_range_key - number_range_returned_quantity.
      loop at entities_wo_travelid into entity.

       travel_id_max += 1.
       entity-TravelId = travel_id_max.
       append value #( %CID = entity-%CID
                       %key = entity-%key ) to mapped-travel.
      ENDLOOP.



  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
  data max_booking_id type /dmo/booking_id.


*  STEP 1: get all the Travel request and their booking data
   read entities of zats_ha_travel in LOCAL MODE "local mode means no authorization (i.e do not check for authorizations)
   ENTITY travel by \_Booking
   from CORRESPONDING #( entities )
   link data(bookings).
   "loop at unique ids
   loop at entities ASSIGNING FIELD-SYMBOL(<travel_group>) GROUP BY <travel_group>-TravelId.
*  STEP 2: get the highest booking number which is already there
      loop at bookings into data(ls_booking) using key entity
        where source-Travelid = <travel_group>-Travelid.
        if max_booking_id < ls_booking-target-BookingId.
          max_booking_id = ls_booking-target-BookingId.
        ENDIF.
      ENDLOOP.
*  STEP 3: get the assigned booking number for incoming request
    loop at entities into data(ls_entity) using key entity
        where Travelid = <travel_group>-Travelid.
          loop at ls_entity-%target into data(ls_target).
            if max_booking_id < ls_target-BookingId.
               max_booking_id = ls_target-BookingId.
            ENDIF.
          ENDLOOP.

      ENDLOOP.
*  STEP 4: loop over all the entities of Travel with same Travel id
     loop at entities ASSIGNING FIELD-SYMBOL(<travel>)
         USING KEY entity WHERE Travelid = <travel_group>-TravelId.
*  STEP 5: Assign new booking id to the booking entity inside each travel
        LOOP at <travel>-%target ASSIGNING FIELD-SYMBOL(<booking_wo_numbers>).
          append CORRESPONDING #( <booking_wo_numbers> ) to mapped-booking
          ASSIGNING FIELD-SYMBOL(<mapped_booking>).
          if <mapped_booking>-Bookingid is initial.
             max_booking_id += 10.
             <mapped_booking>-Bookingid = max_booking_id.
          endif.
         ENDLOOP.
    ENDloop.
  ENDLOOP.
  ENDMETHOD.

  METHOD copyTravel.
   data:
         travels type table for CREATE zats_HA_travel\\Travel,
         bookings_cba type table for CREATE zats_ha_travel\\Travel\_Booking,
         booksuppl_cba TYPE TABLE FOR CREATE zats_ha_travel\\Booking\_Supplements.
   "STEP 1: Remove the Travel instances with initial %CID
     read TABLE keys with key %cid = '' into data(key_with_initial_cid).
     ASSERT key_with_initial_cid is INITIAL.
   "STEP 2: Read all Travel,Booking and Booking Supplements
    READ ENTITIES OF zats_ha_travel in local mode
    entity Travel
      all fields with CORRESPONDING #( keys )
      RESULT data(travel_read_result)
      FAILED failed.

    READ ENTITIES OF zats_ha_travel in local mode
    entity Travel by \_Booking
      all fields with CORRESPONDING #( travel_read_result )
      RESULT data(book_read_result)
      FAILED failed.
   READ ENTITIES OF zats_ha_travel in local mode
    entity Booking by \_Supplements
      all fields with CORRESPONDING #( book_read_result )
      RESULT data(bookSupp_read_result)
      FAILED failed.
   "STEP 3: Fill travel internal table for travel data creation - %CID
    loop at travel_read_result ASSIGNING FIELD-SYMBOL(<travel>).
    "Travel data Preparation
     append value #( %CID = keys[ %tky = <travel>-%tky ]-%cid
     %data = CORRESPONDING #( <travel> except travelid )
     ) to travels ASSIGNING FIELD-SYMBOL(<new_travel>).
     <new_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
     <new_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
     <new_travel>-OverallStatus = 'O'.

   "STEP 4: Fill Booking internal table for booking data creation - %CID_ref during creation the %CID of Travel will be passed to %CID-ref
   "        to inform the RAP framework that the booking belongs to that Travel request
     append value #( %CID_ref = keys[ key entity %tky = <travel>-%tky ]-%cid )
      to Bookings_cba ASSIGNING FIELD-SYMBOL(<bookings_cba>).

    loop at book_read_result ASSIGNING FIELD-SYMBOL(<booking>) WHERE  Travelid = <travel>-TravelId.

     APPEND VALUE #( %cid = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId "TOGET READ OF THE WARNING ON KEYS WE HAVE TO USE KEY ENTITY AFTER THE [ 1.e %cid = keys[ KEY ENTITY %tky
                      %data = CORRESPONDING #( book_read_result[ key entity %tky = <booking>-%tky ] EXCEPT  travelid )
     )
        to <bookings_cba>-%target ASSIGNING FIELD-SYMBOL(<new_booking>).


       <new_booking>-BookingStatus = 'N'.
"STEP 5: Fill Booking Supplements internal table for booking supplements data creation

       append value #( %CID_ref = keys[ key entity %tky = <travel>-%tky ]-%cid  && <Booking>-BookingId )
      to booksuppl_cba ASSIGNING FIELD-SYMBOL(<bookSuppl_cba>).

     loop AT booksupp_read_result ASSIGNING FIELD-SYMBOL(<booksuppl>)
        USING KEY entity WHERE TravelId = <travel>-TravelId and
                            BookingId = <booking>-BookingId.


     APPEND VALUE #( %cid = keys[ key entity %tky = <travel>-%tky ]-%cid && <booking>-BookingId && <booksuppl>-BookingSupplementId     "TOGET READ OF THE WARNING ON KEYS WE HAVE TO USE KEY ENTITY AFTER THE [ 1.e %cid = keys[ KEY ENTITY %tky
                      %data = CORRESPONDING #( <bookSuppl> EXCEPT  travelid bookingId )
     )
        to <booksuppl_cba>-%target.


     endloop.
    ENDLOOP.
   ENDLOOP.
   "STEP 6: Modify entity EML to create new BO instance using existing data

    MODIFY ENTITIES OF zats_ha_travel in LOCAL MODE
      ENTITY travel
        create FIELDS ( Agencyid CustomerId  BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus )
          with travels
       create by \_Booking FIELDS (  BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
        with bookings_cba
     ENTITY Booking
       CREATE BY \_Supplements FIELDS ( bookingsupplementid supplementid price currencycode )
         with booksuppl_cba
       mapped data(mapped_create).
       mapped-travel = mapped_create-travel.

  ENDMETHOD.

*//Method to control create button appearance in Booking Creation
  METHOD get_instance_features.
     "STEP 1 : Read the Travel Data with status
     READ ENTITies of zats_ha_travel IN LOCAL MODE
     ENTITY Travel
       FIELDS ( travelid OverallStatus )
       WITH CORRESPONDING #( keys )
       RESULT data(travels)
       FAILED failed.
     "STEP 2: return with booking creation posible or not
*     data(lv_allow) = COND #(  )
     read table travels into data(ls_travel) index 1.
     if ls_travel-OverallStatus = 'X' .
         data(lv_allow) = if_abap_behv=>fc-o-disabled.
     else.
         lv_allow = if_abap_behv=>fc-o-enabled.
     endif.
       result = value #( for travel in travels
                      ( %tky = travel-%tky
                        %assoc-_Booking = lv_allow
                      )
       ).
  ENDMETHOD.

ENDCLASS.
