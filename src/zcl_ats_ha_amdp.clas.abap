CLASS zcl_ats_ha_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    INTERFACES if_oo_adt_classrun .

    class-methods  add_number IMPORTING value(a) type i
                                        value(b) type i
                               exporting value(result) type i .
    class-METHODS get_customer_by_id IMPORTING
                                value(i_bp_id) type zats_HA_dte_id
                                EXPORTING value(e_result) type char40.

    CLASS-METHODS GET_PRODUCT_MRP IMPORTING

                                  VALUE(I_TAX) TYPE I
                                  EXPORTING VALUE(OTAB) TYPE ZATS_HA_TT_PRODUCT_MRP.

    CLASS-METHODS get_total_sales for TABLE FUNCTION ZATS_HA_TF.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ATS_HA_AMDP IMPLEMENTATION.


  METHOD add_number by DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
      OPTIONS READ-ONLY  .

      declare X  integer ;
      declare y integer ;

      x := a ;
      y := b ;

      result := :x + :y ;

  ENDMETHOD.


  METHOD get_customer_by_id by database PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
        OPTIONS READ-ONLY using ZATS_HA_BPA  .
     SELECT COMPANY_NAME INTO E_RESULT FROM ZATS_HA_BPA WHERE BP_ID = :I_BP_ID ;
  ENDMETHOD.


  METHOD get_product_mrp by database PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
        OPTIONS READ-ONLY using ZATS_HA_PRODUCT  .

*      Declare VARAIBLE
     declare lv_count integer;
     declare i integer;
     declare lv_mrp bigint;
     declare lv_price_d integer;
*     GET ALL THE PRODUCT IN AN IMPLICT INTERNAL TABLE
     lt_prod = select * from zats_ha_product;

*     GET THE RECORD COUNT OF THE TABLE RECORD
      lv_count  := record_count( :lt_prod );
*      lv_count := lines(  :lt_prod );


*     LOOP AT EACH RECORD ONE BY ONE AND CALCULATE THE PRICE AFTER DISCOUNT
      for i in 1..:lv_count do
*     CALCULATE THE MRP based on Input tax
      lv_price_d := :lt_prod.price[i] * ( 100 - :lt_prod.discount [ i ] ) / 100;
      lv_mrp := lv_price_d * (  100 + :i_tax ) / 100;
*     if the MRP is more than 15k an additional 10% discount to be applied
      if lv_mrp > 15000 then
        lv_mrp := lv_mrp * 0.90;
      END IF ;
*     fill the otab for the result
        :otab.insert( (
              :lt_prod.name[ i ],
              :lt_prod.category[ i ],
              :lt_prod.price[ i ],
              :lt_prod.currency[ i ],
              :lt_prod.discount[ i ],
              :lv_price_d ,
              :lv_mrp
         ), i );

      END FOR ;

  ENDMETHOD.


  METHOD get_total_sales BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING zats_ha_bpa zats_ha_so_hdr zats_ha_so_item.
      return
              SELECT
                   bpa.client,
                   bpa.company_name,
                   sum( item.amount ) as total_sales,
                   item.currency as currency_code,
                   RANK ( ) OVER ( ORDER BY sum( item.amount ) desc ) as customer_rank
              from zats_ha_bpa as bpa
              inner join zats_ha_so_hdr as sls
              on bpa.bp_id = sls.buyer
              inner join zats_ha_so_item as item
              on sls.order_id = item.order_id
              group by bpa.client,
                       bpa.company_name,
                       item.currency;

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
*   zcl_ats_ha_amdp=>add_number(
*    EXPORTING
*      a      =  10
*      b      =  20
*    IMPORTING
*      result =  data(lv_res)
*  ).

*   out->write(
*     EXPORTING
*       data   = |The Result of AMDP Execution is -->{  lv_res }|
*   zcl_ats_ha_amdp=>get_customer_by_id(
*  EXPORTING
*    i_bp_id  = '467F809CEAFB1EDFA3C51D9356C80360'
*  IMPORTING
*    e_result = DATA(LV_RES)
*  ).
* OUT->write(
*   EXPORTING
*     data   = LV_RES
*
*   ).
 zcl_ats_ha_amdp=>get_product_mrp(
   EXPORTING
     i_tax = 18
   IMPORTING
     otab  = data(result)
 ).

 out->write(
   EXPORTING
     data   = result
*     name   =
*   RECEIVING
*     output =
 ).
  ENDMETHOD.
ENDCLASS.
