@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZHAK_Travel as select from /dmo/travel_m
composition[0..1] of ZHAK_Booking as _Booking
association[1] to /DMO/I_Agency as _agency on
$projection.AgencyId = _agency.AgencyID
association[1] to /DMO/I_Customer as _customer on
$projection.CustomerId = _customer.CustomerID
association[1] to /DMO/I_Overall_Status_VH as _overall_status_vh on
$projection.OverallStatus = _overall_status_vh.OverallStatus 
association[1] to I_Currency as _currency on 
$projection.CurrencyCode = _currency.Currency 
association[1..1] to /DMO/I_Overall_Status_VH_Text as _overall_status_text on 
$projection.OverallStatus = _overall_status_text.OverallStatus and
  _overall_status_text.Language = 'E'

{
    key travel_id as TravelId,
    agency_id as AgencyId,
    customer_id as CustomerId,
    begin_date as BeginDate,
    end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price as TotalPrice,
    currency_code as CurrencyCode,
    description as Description,
    overall_status as OverallStatus,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
     _agency,
     _customer,
     _overall_status_vh,
     _currency,
     _overall_status_text,
      _Booking
     
      
     
     
    
}
