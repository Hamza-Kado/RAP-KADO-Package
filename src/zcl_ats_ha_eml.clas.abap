CLASS zcl_ats_ha_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  data: lv_opr type c value 'U'.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ATS_HA_EML IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*  types: tt_root_failed  type TABLE FOR failed.

*   data: it_f for create .
   CASE lv_opr.

     WHEN 'R'.
       READ ENTITIES OF zats_ha_travel
       ENTITY Travel
*       ALL FIELDS WITH "reading all the feilds in the table
       FIELDS (  Travelid agencyid customerid overallstatus ) WITH "Specifying feilds to read
       VALUE #( ( Travelid = '00000020' )
                ( Travelid = '00000024' )
                ( Travelid = '0011100024' )
       )
       RESULT DATA(it_result)
       FAILED data(it_failed)
       REPORTED DATA(it_messages).
       out->write(
         EXPORTING
           data   = it_result

       ).

       out->write(
         EXPORTING
           data   = it_failed

       ).

     WHEN 'C'.
       data(lv_desc) = 'Hamza Rocks with RAP'.
       data(lv_agency) = '070014'.
       data(lv_customer) = '000640'.

       modify ENTITIES OF ZATS_HA_travel
       ENTITY Travel
       CREATE FIELDS (  Agencyid currencyCode Begindate enddate description ) " OverallStatus )
       WITH VALUE #(
*       NOTE THAT %CID IS MANDATORY FOR CREATING A RECORD AND THE %CID MUST BE UNIQUE FOR EACH RECORD
                     (  %CID = 'Create'
                      TravelId = '00012348'  AgencyId = lv_agency CustomerId = lv_customer
                        BeginDate = cl_abap_context_info=>get_system_date( )
                        EndDate  = cl_abap_context_info=>get_system_date(  ) + 30
                        Description = lv_desc
                        OverallStatus = 'O'
                        )

                     (   %CID = 'Create-1'
                        TravelId = '00012349'  AgencyId = lv_agency CustomerId = lv_customer
                        BeginDate = cl_abap_context_info=>get_system_date( )
                        EndDate  = cl_abap_context_info=>get_system_date(  ) + 30
                        Description = lv_desc
                        OverallStatus = 'O'
                        )
                   )
                MAPPED data(it_mapped)
                failed it_failed
                REPORTED it_messages.
                COMMIT ENTITIES.
*                out->write(
*                         EXPORTING
*                           data   = it_mapped
*
*                       )
                out->write(
                         EXPORTING
                           data   = it_failed

                       ).
                out->write(
                         EXPORTING
                           data   = it_messages

                       ).


     WHEN 'U'.
          lv_desc = 'WOW!! Hamza Rocks with RAP'.
          lv_agency = '070032'.
         modify ENTITIES OF ZATS_HA_travel
         ENTITY Travel
         UPDATE FIELDS ( Agencyid  description )
         WITH VALUE #(
                     (   TravelId = '00000013'
                         AgencyId = lv_agency
                         Description = lv_desc
                     )

                    )
                MAPPED it_mapped
                failed it_failed
                REPORTED it_messages.
                COMMIT ENTITIES.

                out->write(
                         EXPORTING
                           data   =  it_mapped

                       ).


     WHEN 'D'.
         MODIFY ENTITIES OF zats_ha_travel
         ENTITY Travel
         delete from  VALUE #( ( Travelid = '00012349' ) )
         FAILED it_failed
         REPORTED data(it_reported).
         COMMIT ENTITIES.

         out->write(
                         EXPORTING
                           data   = it_reported

                       ).
         out->write(
                         EXPORTING
                           data   = it_failed

                       ).





   ENDCASE.

  ENDMETHOD.
ENDCLASS.
